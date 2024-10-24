// immutable_list_bench_test.v
module immutable_list

import time

struct BenchResult {
  op_name string
  duration i64
}

fn create_test_list(size int) List[int] {
  mut list := new[int]()
  for i := size - 1; i >= 0; i-- {
    list = list.prepend(i)
  }
  return list
}

fn bench_prepend() BenchResult {
  mut list := new[int]()
  sw := time.new_stopwatch()

  for i := 0; i < 10000; i++ {
    list = list.prepend(i)
  }

  return BenchResult{
    op_name: 'prepend'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_append() BenchResult {
  mut list := new[int]()
  sw := time.new_stopwatch()

  for i := 0; i < 1000; i++ {
    list = list.append(i)
  }

  return BenchResult{
    op_name: 'append'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_array_prepend() BenchResult {
  mut arr := []int{}
  sw := time.new_stopwatch()

  for i := 0; i < 10000; i++ {
    arr.insert(0, i)
  }

  return BenchResult{
    op_name: 'array_prepend'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_array_append() BenchResult {
  mut arr := []int{}
  sw := time.new_stopwatch()

  for i := 0; i < 10000; i++ {
    arr << i
  }

  return BenchResult{
    op_name: 'array_append'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_concatenation() BenchResult {
  list1 := create_test_list(500)
  list2 := create_test_list(500)
  sw := time.new_stopwatch()

  result := list1 + list2
  _ = result

  return BenchResult{
    op_name: 'list_concat'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_array_concatenation() BenchResult {
  arr1 := []int{len: 500, init: index}
  arr2 := []int{len: 500, init: index}
  sw := time.new_stopwatch()

  mut result := arr1.clone()
  result << arr2
  _ = result

  return BenchResult{
    op_name: 'array_concat'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_subtraction() BenchResult {
  list1 := create_test_list(1000)
  list2 := create_test_list(100)  // Remove first 100 numbers
  sw := time.new_stopwatch()

  result := list1 - list2
  _ = result

  return BenchResult{
    op_name: 'list_subtract'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_map() BenchResult {
  list := create_test_list(1000)
  sw := time.new_stopwatch()

  result := map_int(list, fn (x int) int { return x * 2 })
  _ = result

  return BenchResult{
    op_name: 'map'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_array_map() BenchResult {
  arr := []int{len: 1000, init: index}
  sw := time.new_stopwatch()

  result := arr.map(fn (x int) int { return x * 2 })
  _ = result

  return BenchResult{
    op_name: 'array_map'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_filter() BenchResult {
  list := create_test_list(1000)
  sw := time.new_stopwatch()

  result := list.filter(fn (x int) bool { return x % 2 == 0 })
  _ = result

  return BenchResult{
    op_name: 'filter'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_array_filter() BenchResult {
  arr := []int{len: 1000, init: index}
  sw := time.new_stopwatch()

  result := arr.filter(fn (x int) bool { return x % 2 == 0 })
  _ = result

  return BenchResult{
    op_name: 'array_filter'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_reduce() BenchResult {
  list := create_test_list(1000)
  sw := time.new_stopwatch()

  result := list.reduce(0, fn (acc int, x int) int { return acc + x })
  _ = result

  return BenchResult{
    op_name: 'reduce'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_array_reduce() BenchResult {
  arr := []int{len: 1000, init: index}
  sw := time.new_stopwatch()

  mut sum := 0
  for x in arr {
    sum += x
  }
  _ = sum

  return BenchResult{
    op_name: 'array_reduce'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_reverse() BenchResult {
  list := create_test_list(1000)
  sw := time.new_stopwatch()

  result := list.reverse()
  _ = result

  return BenchResult{
    op_name: 'reverse'
    duration: sw.elapsed().microseconds()
  }
}

fn bench_array_reverse() BenchResult {
  mut arr := []int{len: 1000, init: index}
  sw := time.new_stopwatch()

  arr.reverse_in_place()

  return BenchResult{
    op_name: 'array_reverse'
    duration: sw.elapsed().microseconds()
  }
}

fn print_comparison(list_result BenchResult, array_result BenchResult) {
  eprintln('${list_result.op_name} vs ${array_result.op_name}:')
  eprintln('  List:  ${list_result.duration}μs')
  eprintln('  Array: ${array_result.duration}μs')
  eprintln('  Ratio: ${f64(array_result.duration) / f64(list_result.duration):.2f}x')
  eprintln('')
}

fn test_benchmarks() {
  eprintln('\n=== Running List vs Array Benchmarks ===')

  // Basic operations
  list_prepend := bench_prepend()
  array_prepend := bench_array_prepend()
  print_comparison(list_prepend, array_prepend)

  list_append := bench_append()
  array_append := bench_array_append()
  print_comparison(list_append, array_append)

  // List operations
  list_concat := bench_concatenation()
  array_concat := bench_array_concatenation()
  print_comparison(list_concat, array_concat)

  subtraction := bench_subtraction()
  eprintln('List subtraction:')
  eprintln('  Duration: ${subtraction.duration}μs')
  eprintln('')

  // Transformations
  list_map := bench_map()
  array_map := bench_array_map()
  print_comparison(list_map, array_map)

  list_filter := bench_filter()
  array_filter := bench_array_filter()
  print_comparison(list_filter, array_filter)

  list_reduce := bench_reduce()
  array_reduce := bench_array_reduce()
  print_comparison(list_reduce, array_reduce)

  list_reverse := bench_reverse()
  array_reverse := bench_array_reverse()
  print_comparison(list_reverse, array_reverse)

  eprintln('=== Benchmark Complete ===\n')
  assert true
}
