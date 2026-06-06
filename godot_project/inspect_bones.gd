@tool
extends EditorScript

func _run():
	var gltf_doc = GLTFDocument.new()
	var gltf_state = GLTFState.new()
	var path = "D:/otroShooter/app/src/main/assets/FiringRifle-webp.glb"
	
	var err = gltf_doc.append_from_file(path, gltf_state)
	if err != OK:
		print("Error cargando GLB: ", err)
		return
		
	var root = gltf_doc.generate_scene(gltf_state)
	if root:
		_find_skeleton(root)

func _find_skeleton(node: Node):
	if node is Skeleton3D:
		print("--- Esqueleto de FiringRifle ---")
		for i in range(min(5, node.get_bone_count())):
			print(node.get_bone_name(i))
		print("... y ", node.get_bone_count() - 5, " huesos más.")
		return
	for child in node.get_children():
		_find_skeleton(child)
