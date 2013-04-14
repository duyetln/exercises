def bubble_sort(array)
  result = array.dup
  return result if result.length <= 1
  
  boundary_index = result.length
  
  while boundary_index > 0
    result.each_index do |index|
      if index < boundary_index - 1 && result[index + 1] < result[index]
        result[index], result[index + 1] = result[index + 1], result[index] 
      end
    end
    boundary_index -= 1
  end
  result
end
