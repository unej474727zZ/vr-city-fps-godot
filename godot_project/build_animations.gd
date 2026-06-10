@tool
extends EditorScript

var mixamo_to_ue5 = {
	"mixamorig1_Hips": "pelvis",
	"mixamorig1_Spine": "spine_01",
	"mixamorig1_Spine1": "spine_02",
	"mixamorig1_Spine2": "spine_03",
	"mixamorig1_Neck": "neck_01",
	"mixamorig1_Head": "head",
	"mixamorig1_LeftShoulder": "clavicle_l",
	"mixamorig1_LeftArm": "upperarm_l",
	"mixamorig1_LeftForeArm": "lowerarm_l",
	"mixamorig1_LeftHand": "hand_l",
	"mixamorig1_RightShoulder": "clavicle_r",
	"mixamorig1_RightArm": "upperarm_r",
	"mixamorig1_RightForeArm": "lowerarm_r",
	"mixamorig1_RightHand": "hand_r",
	"mixamorig1_LeftUpLeg": "thigh_l",
	"mixamorig1_LeftLeg": "calf_l",
	"mixamorig1_LeftFoot": "foot_l",
	"mixamorig1_LeftToeBase": "ball_l",
	"mixamorig1_RightUpLeg": "thigh_r",
	"mixamorig1_RightLeg": "calf_r",
	"mixamorig1_RightFoot": "foot_r",
	"mixamorig1_RightToeBase": "ball_r",
	"mixamorig1_LeftHandThumb1": "thumb_01_l",
	"mixamorig1_LeftHandThumb2": "thumb_02_l",
	"mixamorig1_LeftHandThumb3": "thumb_03_l",
	"mixamorig1_LeftHandIndex1": "index_01_l",
	"mixamorig1_LeftHandIndex2": "index_02_l",
	"mixamorig1_LeftHandIndex3": "index_03_l",
	"mixamorig1_LeftHandMiddle1": "middle_01_l",
	"mixamorig1_LeftHandMiddle2": "middle_02_l",
	"mixamorig1_LeftHandMiddle3": "middle_03_l",
	"mixamorig1_LeftHandRing1": "ring_01_l",
	"mixamorig1_LeftHandRing2": "ring_02_l",
	"mixamorig1_LeftHandRing3": "ring_03_l",
	"mixamorig1_LeftHandPinky1": "pinky_01_l",
	"mixamorig1_LeftHandPinky2": "pinky_02_l",
	"mixamorig1_LeftHandPinky3": "pinky_03_l",
	"mixamorig1_RightHandThumb1": "thumb_01_r",
	"mixamorig1_RightHandThumb2": "thumb_02_r",
	"mixamorig1_RightHandThumb3": "thumb_03_r",
	"mixamorig1_RightHandIndex1": "index_01_r",
	"mixamorig1_RightHandIndex2": "index_02_r",
	"mixamorig1_RightHandIndex3": "index_03_r",
	"mixamorig1_RightHandMiddle1": "middle_01_r",
	"mixamorig1_RightHandMiddle2": "middle_02_r",
	"mixamorig1_RightHandMiddle3": "middle_03_r",
	"mixamorig1_RightHandRing1": "ring_01_r",
	"mixamorig1_RightHandRing2": "ring_02_r",
	"mixamorig1_RightHandRing3": "ring_03_r",
	"mixamorig1_RightHandPinky1": "pinky_01_r",
	"mixamorig1_RightHandPinky2": "pinky_02_r",
	"mixamorig1_RightHandPinky3": "pinky_03_r"
}

func _run():
	print("--- INICIANDO CONSTRUCCIÓN DE LIBRERÍA DE ANIMACIONES ---")
	
	var library = AnimationLibrary.new()
	
	# Definimos nuestro mapa de animaciones: "Nombre Final" : "Ruta Absoluta al Archivo"
	var anim_sources = {
		"Idle": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Idle/M_Neutral_Stand_Idle_Loop_Rifle.FBX",
		"Run": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Run/M_Neutral_Run_Loop_F_Rifle.FBX",
		"Walk_B": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Walk/M_Neutral_Walk_Loop_B_Rifle.FBX",
		"Walk": "D:/vr_city_fps/godot_project/assets/models/player/GaspFix/_FixedRifle/Walk/M_Neutral_Walk_Loop_F_Rifle.FBX",
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
			# Construimos una animación 100% NUEVA para romper el candado de "solo lectura" de Godot
			var final_anim = Animation.new()
			final_anim.length = anim.length
			final_anim.step = anim.step
			
			# Copiamos pista por pista
			for i in range(anim.get_track_count()):
				var track_type = anim.track_get_type(i)
				var track_path = str(anim.track_get_path(i))
				var parts = track_path.split(":")
				
				var bone_name = ""
				if parts.size() > 1:
					bone_name = parts[1]
					if mixamo_to_ue5.has(bone_name):
						bone_name = mixamo_to_ue5[bone_name] # Traducir hueso!

				# ¡SÚPER FILTRO IN-PLACE! Ignorar posición de cualquier hueso central
				var is_root_bone = (bone_name == "pelvis" or bone_name == "root" or bone_name == "mixamorig1_Hips" or bone_name.to_lower().find("hips") != -1)
				if is_root_bone and (track_type == Animation.TYPE_POSITION_3D or track_path.ends_with(":position")):
					continue

				var new_idx = final_anim.add_track(track_type)
				
				if bone_name != "":
					final_anim.track_set_path(new_idx, NodePath("Skeleton3D:" + bone_name))
				else:
					final_anim.track_set_path(new_idx, NodePath(track_path))
					
				# Copiar propiedades de la pista
				final_anim.track_set_interpolation_type(new_idx, anim.track_get_interpolation_type(i))
				final_anim.track_set_interpolation_loop_wrap(new_idx, anim.track_get_interpolation_loop_wrap(i))
				
				# Copiar todos los keyframes
				for k in range(anim.track_get_key_count(i)):
					var time = anim.track_get_key_time(i, k)
					var val = anim.track_get_key_value(i, k)
					var trans = anim.track_get_key_transition(i, k)
					final_anim.track_insert_key(new_idx, time, val, trans)
			
			if anim_name == "Idle" or anim_name == "Run" or anim_name == "Walk_B" or anim_name == "Walk":
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
