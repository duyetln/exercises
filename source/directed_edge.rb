class DirectedEdge < Edge
  attr_reader :source, :destination
  
  def initialize(weight = 0, source, destination)
    super(weight, source, destination)
    @source = source
    @destination = destination
  end
end
