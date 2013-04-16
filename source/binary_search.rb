def binary_search(array, target, index_min, index_max)
  return nil if array.empty? || index_max < index_min
  
  index_middle = (index_min + index_max)/2
  
  if array[index_middle] < target
    return binary_search(array, target, index_middle + 1, index_max)
  elsif array[index_middle] > target
    return binary_search(array, target, index_min, index_middle - 1)
  else
    return index_middle
  end
end
