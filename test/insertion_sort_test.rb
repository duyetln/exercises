require '../source/insertion_sort.rb'
require 'test/unit'

class InsertionSortTest < Test::Unit::TestCase

  def setup
    @empty = []
    @one = [2]
    @two = [4, 3]
    @many = [1, 5, 2, 6, 3, 7, 9, 2]
    @identical = [3, 3, 3, 2, 2, 1, 1, 6]
    
    @empty_orig = @empty.dup
    @one_orig = @one.dup
    @two_orig = @two.dup
    @many_orig = @many.dup
    @identical_orig = @identical.dup
  end
  
  def test_insertion_sort
    assert insertion_sort(@empty) == @empty.sort
    assert insertion_sort(@one) == @one.sort
    assert insertion_sort(@two) == @two.sort
    assert insertion_sort(@many) == @many.sort
    assert insertion_sort(@identical) == @identical.sort
    
    assert @empty == @empty_orig
    assert @one == @one_orig
    assert @two == @two_orig
    assert @many == @many_orig
    assert @identical == @identical_orig
  end
end
