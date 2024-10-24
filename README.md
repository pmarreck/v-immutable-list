# Immutable List in V

This project implements an immutable list data structure in the [V programming language](https://vlang.io/). The list is designed to be immutable, meaning that operations on the list return new lists rather than modifying the original.

This approach is inspired by functional programming paradigms, ensuring that data remains consistent and predictable.

## Features

- **Immutable Operations**: All list operations return new lists, preserving the original.
- **Functional Methods**: Includes methods like `map`, `filter`, and `reduce` for functional-style programming.
- **Operator Overloading**: Supports `+` for concatenation and `-` for subtraction of lists.
- **Benchmarks**: Performance benchmarks comparing list operations to native array operations.
- **Comprehensive Tests**: Unit tests covering all functionalities to ensure correctness.

## Installation

To use this project, ensure you have the V language installed. You can download it from the [official V website](https://vlang.io/).

Clone the repository and navigate to the project directory:

```bash
git clone git@github.com:pmarreck/v-immutable-list.git
cd v-immutable-list
```

## Usage

The main implementation is in `immutable_list.v` . You can include this module in your V projects to utilize the immutable list functionality.

As this is my first V project and the first time I've ever implemented an immutable list, there may be some suboptimal design decisions, bugs or issues. Please feel free to open an issue or submit a pull request if you find any problems.

### Running Tests

To run the tests and benchmarks, execute the following command:

./test

This script uses the V compiler to run all tests in the project directory.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.

## Contact

For any questions or feedback, please open an issue on the GitHub repository.
