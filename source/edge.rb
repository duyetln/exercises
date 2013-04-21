class Edge
  attr_reader :weight, :endpoints
  
  def initialize(weight = 0, first_node, second_node)
    @weight = weight
    @endpoints = [first_node, second_node]
  end
end
