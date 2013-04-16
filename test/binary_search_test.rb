require '../source/binary_search.rb'
require 'test/unit'

class BinarySearchTest < Test::Unit::TestCase

  def setup
    @empty = [].sort
    @one = [2].sort
    @two = [4, 3].sort
    @many = [1, 5, 2, 6, 3, 7, 9, 2].sort
    @identical = [3, 3, 3, 2, 2, 1, 1, 6].sort
    
    @empty_orig = @empty.dup
    @one_orig = @one.dup
    @two_orig = @two.dup
    @many_orig = @many.dup
    @identical_orig = @identical.dup
  end
  
  def test_binary_search
    assert binary_search(@empty, rand.ceil, 0, 0).nil?
    assert @one[binary_search(@one, 2, 0, @one.length - 1)] == 2
    assert binary_search(@one, 3, 0, @one.length - 1).nil?
    assert @two[binary_search(@two, 3, 0, @two.length - 1)] == 3
    assert @two[binary_search(@two, 4, 0, @two.length - 1)] == 4
    assert binary_search(@two, 6, 0, @two.length - 1).nil?
    assert @many[binary_search(@many, 7, 0, @many.length - 1)] == 7
    assert binary_search(@many, 10, 0, @many.length - 1).nil?
    assert @identical[binary_search(@identical, 3, 0, @identical.length - 1)] == 3
    
    assert @empty == @empty_orig
    assert @one == @one_orig
    assert @two == @two_orig
    assert @many == @many_orig
    assert @identical == @identical_orig
  end
end
