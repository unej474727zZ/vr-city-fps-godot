@tool
extends SceneTree

func _init():
	var doc = GLTFDocument.new()
	var state = GLTFState.new()
	doc.append_from_file("res://assets/animations/Rifleidle.glb", state)
	var scene = doc.generate_scene(state)
	print("--- Scene inside Rifleidle.glb ---")
	_print_node(scene, "")
	quit()

func _print_node(node: Node, indent: String):
	print(indent, node.name, " (", node.get_class(), ")")
	for c in node.get_children():
		_print_node(c, indent + "  ")
