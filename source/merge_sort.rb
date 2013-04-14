def merge(first_array, second_array)
  first_index = 0
  second_index = 0
  result = []
  
  while first_index < first_array.length || second_index < second_array.length
    if (second_index >= second_array.length && first_index < first_array.length) || \
       (first_index < first_array.length && second_index < second_array.length && \
        first_array[first_index] <= second_array[second_index])
      result << first_array[first_index]
      first_index += 1
    elsif (first_index >= first_array.length && second_index < second_array.length) || \
            (first_index < first_array.length && second_index < second_array.length && \
             first_array[first_index] > second_array[second_index])
      result << second_array[second_index]
      second_index += 1
    end
  end
  result  
end

def merge_sort(array)
  result = array.dup
  return result if array.length <= 1
  
  size = result.length
  middle = (size-1)/2
  return merge(merge_sort(result[0..middle]), merge_sort(result[(middle+1)...size]))
end
