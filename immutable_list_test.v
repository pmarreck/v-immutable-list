// immutable_list_test.v
module immutable_list

fn test_basic_operations() {
	list1 := new[int]()
	assert list1.len() == 0
	assert list1.head() == none

	list2 := initialize(42)
	assert list2.len() == 1
	assert list2.head()? == 42

	list3 := list2.prepend(41)
	assert list3.len() == 2
	assert list3.head()? == 41
	assert list2.head()? == 42  // Original unchanged

	tail := list3.tail()?
	assert tail.len() == 1
	assert tail.head()? == 42
	assert list3.len() == 2  // Original unchanged
}

fn test_append() {
	list := initialize(1).append(2).append(3)
	assert list.to_array() == [1, 2, 3]
}

fn test_functional_operations() {
	base := initialize(1).append(2).append(3).append(4)

	// Map integers using the free function
	doubled := map_int(base, fn (x int) int { return x * 2 })
	assert doubled.to_array() == [2, 4, 6, 8]
	assert base.to_array() == [1, 2, 3, 4]  // Original unchanged

	// Filter
	evens := base.filter(fn (x int) bool { return x % 2 == 0 })
	assert evens.to_array() == [2, 4]
	assert base.to_array() == [1, 2, 3, 4]  // Original unchanged

	// reduce
	sum := base.reduce(0, fn (acc int, x int) int { return acc + x })
	assert sum == 10
	assert base.to_array() == [1, 2, 3, 4]  // Original unchanged
}

fn test_reverse() {
	original := initialize(1).append(2).append(3)
	reversed := original.reverse()

	assert reversed.to_array() == [3, 2, 1]
	assert original.to_array() == [1, 2, 3]  // Original unchanged
}

fn test_contains() {
  list := initialize(1).append(2).append(3)

  assert list.contains(1)
  assert list.contains(2)
  assert list.contains(3)
  assert !list.contains(4)
}

fn test_decompose() {
	list := initialize(1).append(2).append(3)

	head, tail := list.decompose()?
	assert head == 1
	assert tail.to_array() == [2, 3]
	assert list.to_array() == [1, 2, 3]  // Original unchanged

	head2, tail2 := tail.decompose()?
	assert head2 == 2
	assert tail2.to_array() == [3]
}

fn test_string_operations() {
	list := initialize('hello').append('world')
	mapped := map_string(list, fn (s string) string { return s.to_upper() })

	assert mapped.to_array() == ['HELLO', 'WORLD']
	assert list.to_array() == ['hello', 'world']  // Original unchanged
}

fn test_concatenation() {
  // Test with integers
  list1 := initialize(1).append(2).append(3)  // [1,2,3]
  list2 := initialize(4).append(5)            // [4,5]

  int_result := list1 + list2
  assert int_result.to_array() == [1, 2, 3, 4, 5]
  assert list1.to_array() == [1, 2, 3]  // Verify original unchanged
  assert list2.to_array() == [4, 5]     // Verify original unchanged

  // Test with strings
  str_list1 := initialize('a').append('b')
  str_list2 := initialize('c').append('d')

  str_result := str_list1 + str_list2
  assert str_result.to_array() == ['a', 'b', 'c', 'd']

  // Test edge cases
  empty := new[int]()
  assert (empty + list1).to_array() == [1, 2, 3]
  assert (list1 + empty).to_array() == [1, 2, 3]
  assert (empty + empty).to_array() == []
}

fn test_subtraction() {
  // Test basic subtraction
  list1 := initialize(1).append(2).append(3).append(2).append(4)  // [1,2,3,2,4]
  list2 := initialize(2).append(4)                                // [2,4]

  result := list1 - list2
  assert result.to_array() == [1, 3]  // Should remove all 2's and 4

  // Verify originals unchanged
  assert list1.to_array() == [1, 2, 3, 2, 4]
  assert list2.to_array() == [2, 4]

  // Test edge cases
  empty := new[int]()
  assert (list1 - empty).to_array() == [1, 2, 3, 2, 4]  // Subtracting empty list changes nothing
  assert (empty - list1).to_array() == []               // Empty minus anything is empty
  assert (empty - empty).to_array() == []               // Empty minus empty is empty

  // Test with no matches
  list3 := initialize(5).append(6)
  assert (list1 - list3).to_array() == [1, 2, 3, 2, 4]  // No elements in common
}
