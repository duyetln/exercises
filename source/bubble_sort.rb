def bubble_sort(array)
  result = array.dup
  return result if result.length <= 1
  
  last_unsorted = result.length
  
  while last_unsorted > 0
    result.each_index do |index|
      if index < last_unsorted - 1 && result[index] > result[index+1]
        result[index], result[index+1] = result[index+1], result[index] 
      end
    end
    last_unsorted -= 1
  end
  result
end
