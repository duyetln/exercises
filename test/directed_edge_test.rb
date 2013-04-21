require '../source/selection_sort.rb'
require '../source/node.rb'
require '../source/edge.rb'
require '../source/directed_edge.rb'
require '../source/undirected_edge.rb'
require '../source/tree_node.rb'
require 'test/unit'

class DirectedEdgeTest < Test::Unit::TestCase

  def setup
    @source = Node.new
    @destination = Node.new
    @edge = DirectedEdge.new(2, @source, @destination)
  end
  
  def test_weight
    assert @edge.weight == 2
  end
  
  def test_source
    assert @edge.source == @source
  end
  
  def test_destination
    assert @edge.destination == @destination
  end
  
  def test_endpoints
    assert @edge.endpoints.include? @source
    assert @edge.endpoints.include? @destination
    assert @edge.endpoints.size == 2
  end

end
