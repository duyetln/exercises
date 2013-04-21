def depth_first_tree_traverse(tree_node, &block)
  block.call(tree_node)
  return if tree_node.leaf?
  tree_node.children.each do |child|
    depth_first_tree_traverse(child, &block)
  end
end
