@tool
extends EditorScript

func _run():
	print("--- INICIANDO CONSTRUCCIÓN DE LIBRERÍA DE ANIMACIONES ---")
	
	var library = AnimationLibrary.new()
	
	# Definimos nuestro mapa de animaciones: "Nombre Final" : "Ruta Absoluta al Archivo"
	var anim_sources = {
		"Idle": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Idle/M_Neutral_Stand_Idle_Loop_Rifle.FBX",
		"Run": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Run/M_Neutral_Run_Loop_F_Rifle.FBX",
		"Walk_B": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Walk/M_Neutral_Walk_Loop_B_Rifle.FBX",
		"Jump": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Jump/M_Neutral_Jump_F_Start_Run_Lfoot_Rifle.FBX",
		"Shoot": "D:/otroShooter/app/src/main/assets/FiringRifle-webp.glb",
		"Prone": "D:/otroShooter/app/src/main/assets/ProneForward-webp.glb"
	}
	
	for anim_name in anim_sources.keys():
		var path = anim_sources[anim_name]
		print("Extrayendo: ", anim_name, " desde ", path.get_file())
		
		var anim = null
		
		# Si es un FBX dentro de nuestro proyecto, lo cargamos como escena importada
		if path.ends_with(".FBX") or path.ends_with(".fbx"):
			var local_path = path.replace("D:/vr_city_fps/godot_project/", "res://")
			var scene = load(local_path)
			if scene:
				var node = scene.instantiate()
				var player = _find_first_animation_player(node)
				if player:
					var list = player.get_animation_list()
					if list.size() > 0:
						anim = player.get_animation(list[0])
				node.queue_free()
		
		# Si es un GLB externo, lo cargamos crudo con GLTFDocument
		elif path.ends_with(".glb"):
			var doc = GLTFDocument.new()
			var state = GLTFState.new()
			if doc.append_from_file(path, state) == OK:
				var node = doc.generate_scene(state)
				var player = _find_first_animation_player(node)
				if player:
					var list = player.get_animation_list()
					if list.size() > 0:
						anim = player.get_animation(list[0])
				node.queue_free()
		
		if anim != null:
			# Duplicamos la animación para desvincularla del archivo original
			var final_anim = anim.duplicate()
			if anim_name == "Idle" or anim_name == "Run" or anim_name == "Walk_B":
				final_anim.loop_mode = Animation.LOOP_LINEAR
			else:
				final_anim.loop_mode = Animation.LOOP_NONE
				
			library.add_animation(anim_name, final_anim)
			print("✅ Éxito: ", anim_name, " agregada a la librería.")
		else:
			print("❌ Error: No se pudo extraer la animación de ", path)
	
	# Guardar la librería
	var save_path = "res://combat_anims.res"
	var err = ResourceSaver.save(library, save_path)
	if err == OK:
		print("🎉 ¡LIBRERÍA CREADA CON ÉXITO EN: ", save_path, " !")
	else:
		print("❌ Error guardando el archivo .res: ", err)

func _find_first_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found = _find_first_animation_player(child)
		if found:
			return found
	return null
