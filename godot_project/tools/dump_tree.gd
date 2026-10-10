@tool
extends SceneTree

func _init():
	var scene = load("res://main.tscn")
	var root = scene.instantiate()
	print("=== SCENE TREE DUMP ===")
	_print_tree(root, "")
	quit()

func _print_tree(node, indent):
	print(indent + node.name + " (" + node.get_class() + ")")
	for child in node.get_children(true): # true = include internal nodes!
		_print_tree(child, indent + "  ")
