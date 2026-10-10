@tool
extends EditorScript

func _run():
	print("--- CREANDO BLENDSPACE 2D DE LOCOMOCION ---")
	
	var blend_space = AnimationNodeBlendSpace2D.new()
	
	# Configurar los ejes
	blend_space.min_space = Vector2(-1.0, -1.0)
	blend_space.max_space = Vector2(1.0, 1.0)
	blend_space.snap = Vector2(0.1, 0.1)
	blend_space.blend_mode = AnimationNodeBlendSpace2D.BLEND_MODE_INTERPOLATED
	
	# Función auxiliar para agregar puntos
	var add_point = func(anim_name: String, pos: Vector2):
		var anim_node = AnimationNodeAnimation.new()
		anim_node.animation = "Combat/" + anim_name
		blend_space.add_blend_point(anim_node, pos)
	
	# ============ PUNTOS DEL BLENDSPACE ============
	
	# IDLE (Centro absoluto)
	add_point.call("Idle", Vector2(0.0, 0.0))
	
	# WALK (Radio 0.5)
	add_point.call("Walk_F", Vector2(0.0, 0.5))
	add_point.call("Walk_B", Vector2(0.0, -0.5))
	add_point.call("Walk_L", Vector2(-0.5, 0.0))
	add_point.call("Walk_R", Vector2(0.5, 0.0))
	add_point.call("Walk_FL", Vector2(-0.5, 0.5))
	add_point.call("Walk_FR", Vector2(0.5, 0.5))
	add_point.call("Walk_BL", Vector2(-0.5, -0.5))
	add_point.call("Walk_BR", Vector2(0.5, -0.5))
	
	# RUN (Radio 1.0)
	add_point.call("Run_F", Vector2(0.0, 1.0))
	add_point.call("Run_B", Vector2(0.0, -1.0))
	add_point.call("Run_L", Vector2(-1.0, 0.0))
	add_point.call("Run_R", Vector2(1.0, 0.0))
	add_point.call("Run_FL", Vector2(-1.0, 1.0))
	add_point.call("Run_FR", Vector2(1.0, 1.0))
	add_point.call("Run_BL", Vector2(-1.0, -1.0))
	add_point.call("Run_BR", Vector2(1.0, -1.0))

	# ============ GENERAR TRIANGULOS ============
	# Godot usa Delaunay para triangular por defecto, pero suele hacerlo bien automáticamente
	# cuando los puntos son uniformes.
	
	# Guardar el recurso
	var save_path = "res://locomotion_blendspace.tres"
	var err = ResourceSaver.save(blend_space, save_path)
	if err == OK:
		print("✅ ¡BlendSpace2D creado exitosamente en: ", save_path, " !")
	else:
		print("❌ Error al guardar el BlendSpace2D: ", err)
