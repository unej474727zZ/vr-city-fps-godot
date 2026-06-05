@tool
extends EditorScript

func _run():
	print("Iniciando generacion magica de la CIUDAD CORRECTA (La gris clara)...")
	var gltf_scene = load("res://assets/models/procedural_city_6/scene.gltf")
	if gltf_scene == null:
		print("Error: No se pudo cargar la ciudad GLTF")
		return
	
	var root = gltf_scene.instantiate()
	_add_collisions_recursive(root, root)
	
	var packed = PackedScene.new()
	packed.pack(root)
	ResourceSaver.save(packed, "res://assets/models/ciudad_lista.tscn")
	
	print("==================================================")
	print("¡ÉXITO! Ciudad gris generada en: assets/models/ciudad_lista.tscn")
	print("==================================================")

func _add_collisions_recursive(node: Node, owner_node: Node):
	if node is MeshInstance3D and node.mesh != null:
		var static_body = StaticBody3D.new()
		var col_shape = CollisionShape3D.new()
		col_shape.shape = node.mesh.create_trimesh_shape()
		
		node.add_child(static_body)
		static_body.owner = owner_node
		
		static_body.add_child(col_shape)
		col_shape.owner = owner_node
		
	for child in node.get_children():
		_add_collisions_recursive(child, owner_node)
