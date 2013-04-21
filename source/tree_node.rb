class TreeNode < Node
  attr_accessor :parent
  attr_reader :children, :links
  
  def initialize(value = 0)
    super(value)
    @parent = nil
    @children = []
    @links = []
  end
  
  def link(child, weight = 0)
    unless @children.include? child
      edge = DirectedEdge.new(weight, self, child)
      @links << edge
      @children << child
      child.parent = self
      return edge
    end
    nil
  end
  
  def root?
    @parent.nil?
  end
  
  def leaf?
    @children.empty?
  end
  
  def internal?
    !root? && !leaf?
  end
end
