extends Node

func destroy_children(node: Node):
	for n in node.get_children():
		n.queue_free()
