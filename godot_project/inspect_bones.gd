@tool
extends EditorScript

func _run():
	var gltf_scene = load("res://assets/models/hands/tactical_gloves.glb")
	if gltf_scene == null:
		print("Error: No se pudo cargar tactical_gloves.glb")
		return
	var root = gltf_scene.instantiate()
	_find_skeleton(root)

func _find_skeleton(node: Node):
	if node is Skeleton3D:
		print("¡Esqueleto encontrado!: ", node.name)
		print("Huesos:")
		for i in range(node.get_bone_count()):
			print("- ", node.get_bone_name(i))
		return
	for child in node.get_children():
		_find_skeleton(child)
