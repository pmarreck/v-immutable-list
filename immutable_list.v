// immutable_list.v
module immutable_list

struct Node[T] {
	data T
	next ?&Node[T]
}

pub struct List[T] {
	head ?&Node[T]
	size int
}

// Creates an empty list
pub fn new[T]() List[T] {
	return List[T]{
		head: none
		size: 0
	}
}

// Creates a new list with a single element
pub fn initialize[T](data T) List[T] {
	return List[T]{
		head: &Node[T]{
			data: data
			next: none
		}
		size: 1
	}
}

// Creates a new list by adding an element to the front
pub fn (list List[T]) prepend(data T) List[T] {
	return List[T]{
		head: &Node[T]{
			data: data
			next: list.head
		}
		size: list.size + 1
	}
}

// Returns the first element
pub fn (list List[T]) head() ?T {
	if node := list.head {
		return node.data
	}
	return none
}

// Creates a new list by removing the first element
pub fn (list List[T]) tail() ?List[T] {
	if node := list.head {
		if next := node.next {
			return List[T]{
				head: next
				size: list.size - 1
			}
		}
		return new[T]()
	}
	return none
}

// Creates a new list by adding an element to the end
pub fn (list List[T]) append(data T) List[T] {
	if list.head == none {
		return initialize(data)
	}

	if hd := list.head() {
		if tail := list.tail() {
			return tail.append(data).prepend(hd)
		}
		return initialize(hd).append(data)
	}
	return initialize(data)
}

// Adds two lists together
pub fn (list List[T]) plus[T](other List[T]) List[T] {
  if hd := list.head() {
    if tail := list.tail() {
      return tail.plus(other).prepend(hd)
    }
    return other.prepend(hd)
  }
  return other
}

// Operator overloading for +
pub fn (list List[T]) + (other List[T]) List[T] {
  return list.plus(other)
}

// Subtraction implementation
pub fn (list List[T]) minus[T](other List[T]) List[T] {
  if hd := list.head() {
    if tail := list.tail() {
      rest := tail.minus(other)
      if !other.contains(hd) {
        return rest.prepend(hd)
      }
      return rest
    }
    if !other.contains(hd) {
      return initialize(hd)
    }
  }
  return new[T]()
}

// Operator overloading for -
pub fn (list List[T]) - (other List[T]) List[T] {
  return list.minus(other)
}

// Creates a new list containing only elements that satisfy the predicate
pub fn (list List[T]) filter(f fn (T) bool) List[T] {
	if hd := list.head() {
		if tail := list.tail() {
			rest := tail.filter(f)
			if f(hd) {
				return rest.prepend(hd)
			}
			return rest
		}
		if f(hd) {
			return initialize(hd)
		}
	}
	return new[T]()
}

// Maps integers to integers
pub fn map_int(list List[int], f fn (int) int) List[int] {
	if hd := list.head() {
		if tail := list.tail() {
			return map_int(tail, f).prepend(f(hd))
		}
		return initialize(f(hd))
	}
	return new[int]()
}

// Maps strings to strings
pub fn map_string(list List[string], f fn (string) string) List[string] {
	if hd := list.head() {
		if tail := list.tail() {
			return map_string(tail, f).prepend(f(hd))
		}
		return initialize(f(hd))
	}
	return new[string]()
}

// Reduces the list to a single value
pub fn (list List[T]) reduce[U](init U, f fn (U, T) U) U {
	if hd := list.head() {
		if tail := list.tail() {
			return tail.reduce(f(init, hd), f)
		}
		return f(init, hd)
	}
	return init
}

// Creates a new reversed list
pub fn (list List[T]) reverse() List[T] {
	if hd := list.head() {
		if tail := list.tail() {
			return tail.reverse().append(hd)
		}
		return initialize(hd)
	}
	return new[T]()
}

// Converts to array
pub fn (list List[T]) to_array() []T {
	if hd := list.head() {
		if tail := list.tail() {
			mut result := tail.to_array()
			result.insert(0, hd)
			return result
		}
		return [hd]
	}
	return []T{}
}

// Returns the length
pub fn (list List[T]) len() int {
	return list.size
}

// Pattern matching-style deconstruction
pub fn (list List[T]) decompose() ?(T, List[T]) {
	if node := list.head {
		return node.data, List[T]{
			head: node.next
			size: list.size - 1
		}
	}
	return none
}

// check if an element exists in a list
pub fn (list List[T]) contains(element T) bool {
  if hd := list.head() {
    if hd == element {
      return true
    }
    if tail := list.tail() {
      return tail.contains(element)
    }
  }
  return false
}
