{
  description = "A V library to work with immutable lists";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";  # Import nixpkgs
    flake-utils.url = "github:numtide/flake-utils";  # Flake utils for cross-compilation
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        # Development environment
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.vlang   # Include V in the shell environment
          ];

          shellHook = ''
            echo -e "\033[33mV development environment for ${system} initialized\033[0m"
          '';
        };

        # Build the V project for this system
        packages.default = pkgs.stdenv.mkDerivation {
          name = "v-immutable-list-${system}";

          # Source directory for your V project
          src = ./.;

          buildInputs = [ pkgs.vlang ];

          buildPhase = ''
            v -shared -o $out/bin/v-immutable-list .
          '';

          installPhase = ''
            mkdir -p $out/bin
            mv v-immutable-list.dylib $out/bin/
          '';
        };
      }
    );
}
