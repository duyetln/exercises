def insertion_sort(array)
  result = array.dup
  return result if array.length <= 1
  
  next_index = 0
  
  while next_index < result.length
    swap_index = next_index - 1
    while swap_index >= 0 && result[swap_index] > result[swap_index + 1]
      result[swap_index], result[swap_index + 1] = result[swap_index + 1], result[swap_index]
      swap_index -= 1
    end
    next_index += 1
  end
  result
end
