def selection_sort(array)
  result = array.dup
  return result if array.length <= 1
  
  boundary_index = 0
  min_index = 0
  
  while boundary_index < result.length
    result.each_index do |index|
      min_index = index if index >= boundary_index && result[min_index] > result[index]
    end
    result[boundary_index], result[min_index] = result[min_index], result[boundary_index]
    boundary_index += 1
    min_index = boundary_index
  end
  result
end
