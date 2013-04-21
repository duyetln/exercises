def breadth_first_tree_traverse(tree_node, &block)
  queue = []
  queue << tree_node
  until queue.empty?
    node = queue.shift
    queue += node.children
    block.call(node)
  end
end
