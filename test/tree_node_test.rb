require '../source/selection_sort.rb'
require '../source/node.rb'
require '../source/edge.rb'
require '../source/directed_edge.rb'
require '../source/undirected_edge.rb'
require '../source/tree_node.rb'
require 'test/unit'

class TreeNodeTest < Test::Unit::TestCase

  def setup
    @root = TreeNode.new
    @child1 = TreeNode.new(1)
    @child2 = TreeNode.new(2)
    @child3 = TreeNode.new(3)
    @leaf1 = TreeNode.new(11)
    @leaf2 = TreeNode.new(12)
    
    @pairs = [[@root, @child1], [@root, @child2], [@root, @child3], [@child1, @leaf1], [@child1, @leaf2]]
    @edges = []
    @pairs.each{ |pair| @edges << pair[0].link(pair[1]) }
  end
  
  def test_value
    assert @root.value == 0
    assert @child1.value == 1
    assert @child2.value == 2
    assert @child3.value == 3
    assert @leaf1.value == 11
    assert @leaf2.value == 12
  end

  def test_link
    @pairs.each_index do |index|
      edge = @edges[index]
      source = @pairs[index][0]
      destination = @pairs[index][1]
      assert edge
      assert source.children.include?(destination)
      assert source.links.include?(edge)
      assert destination.parent == source
    end
    
    assert !@root.link(@child1)
    assert !@child1.link(@leaf1)
  end
  
  def test_root
    assert @root.root?
    assert !@child1.root?
    assert !@leaf1.root?
  end
  
  def test_leaf
    assert @leaf1.leaf?
    assert @leaf2.leaf?
    assert !@root.leaf?
    assert !@child1.leaf?
  end
  
end
