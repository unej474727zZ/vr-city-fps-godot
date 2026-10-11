@tool
extends SceneTree

func _init():
	var packed = load("res://main.tscn")
	var root = packed.instantiate()
	print("--- INSPECTING MAIN SCENE NODES ---")
	_inspect_node(root, 0)
	quit()

func _inspect_node(node: Node, depth: int):
	var indent = ""
	for i in range(depth):
		indent += "  "
	var col_info = ""
	if node is CollisionShape3D:
		col_info = " [COLLISION SHAPE: " + str(node.shape) + "]"
	elif node is CollisionObject3D:
		col_info = " [COLLISION OBJECT: layer=" + str(node.collision_layer) + " mask=" + str(node.collision_mask) + "]"
	print(indent + node.name + " (" + node.get_class() + ")" + col_info)
	for child in node.get_children():
		_inspect_node(child, depth + 1)
