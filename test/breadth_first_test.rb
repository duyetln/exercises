require '../source/breadth_first.rb'
require '../source/node.rb'
require '../source/edge.rb'
require '../source/directed_edge.rb'
require '../source/undirected_edge.rb'
require '../source/tree_node.rb'
require 'test/unit'

class BreadthFirstTest < Test::Unit::TestCase

  def setup
    @root = TreeNode.new(0)
    @node1 = TreeNode.new(1)
    @node2 = TreeNode.new(2)
    @node3 = TreeNode.new(3)
    @node4 = TreeNode.new(4)
    @node5 = TreeNode.new(5)
    @node6 = TreeNode.new(6)
    @node7 = TreeNode.new(7)
    
    @root.link(@node1)
    @root.link(@node2)
    @root.link(@node3)
    @node2.link(@node4)
    @node2.link(@node5)
    @node5.link(@node6)
    @node5.link(@node7)
    
    @path = [@root, @node1, @node2, @node3, @node4, @node5, @node6, @node7]
  end
  
  def test_breadth_first_tree_traverse
    path = []
    breadth_first_tree_traverse @root do |node|
      path << node
    end
    
    assert @path == path
  end
end
