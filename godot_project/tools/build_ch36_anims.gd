@tool
extends SceneTree

func _init():
	print("--- CREANDO ESCENA SOLDIER_CH36.TSCN ---")
	
	# 1. Cargar las 6 animaciones limpias de assets/animations
	var dir = "res://assets/animations/"
	var raw_idle = _load_raw_anim(dir + "Rifleidle.glb")
	var raw_walk_f = _load_raw_anim(dir + "Walking.glb")
	var raw_walk_b = _load_raw_anim(dir + "WalkingBackwards.glb")
	var raw_run_f = _load_raw_anim(dir + "Running.glb")
	var raw_jump = _load_raw_anim(dir + "Jump.glb")
	var raw_shoot = _load_raw_anim(dir + "FiringRifle.glb")
	
	var lib = AnimationLibrary.new()
	
	# Idle
	raw_idle.loop_mode = Animation.LOOP_LINEAR
	lib.add_animation("Idle", raw_idle)
	
	# Walk_F con brazos de Idle para apuntar
	var walk_f = _apply_aim_arms(raw_walk_f, raw_idle)
	walk_f.loop_mode = Animation.LOOP_LINEAR
	lib.add_animation("Walk_F", walk_f)
	
	# Walk_B con brazos de Idle para apuntar
	var walk_b = _apply_aim_arms(raw_walk_b, raw_idle)
	walk_b.loop_mode = Animation.LOOP_LINEAR
	lib.add_animation("Walk_B", walk_b)
	
	# Run_F con brazos de Idle para apuntar
	var run_f = _apply_aim_arms(raw_run_f, raw_idle)
	run_f.loop_mode = Animation.LOOP_LINEAR
	lib.add_animation("Run_F", run_f)
	
	# Jump sin bucle
	raw_jump.loop_mode = Animation.LOOP_NONE
	lib.add_animation("Jump", raw_jump)
	
	# Shoot sin bucle
	raw_shoot.loop_mode = Animation.LOOP_NONE
	lib.add_animation("Shoot", raw_shoot)
	
	ResourceSaver.save(lib, "res://ch36_combat_anims.res")
	print("Libreria ch36_combat_anims.res guardada!")
	
	# 2. Configurar BlendSpace de Locomoción
	var bs = AnimationNodeBlendSpace2D.new()
	bs.auto_triangles = true
	var p_idle = AnimationNodeAnimation.new(); p_idle.animation = &"Combat/Idle"
	var p_wf = AnimationNodeAnimation.new(); p_wf.animation = &"Combat/Walk_F"
	var p_rf = AnimationNodeAnimation.new(); p_rf.animation = &"Combat/Run_F"
	var p_wb = AnimationNodeAnimation.new(); p_wb.animation = &"Combat/Walk_B"
	
	bs.add_blend_point(p_idle, Vector2(0, 0))
	bs.add_blend_point(p_wf, Vector2(0, 0.5))
	bs.add_blend_point(p_rf, Vector2(0, 1.0))
	bs.add_blend_point(p_wb, Vector2(0, -0.5))
	bs.add_blend_point(p_wb, Vector2(0, -1.0))
	
	bs.add_blend_point(p_wf, Vector2(-0.5, 0))
	bs.add_blend_point(p_wf, Vector2(0.5, 0))
	bs.add_blend_point(p_rf, Vector2(-1.0, 0))
	bs.add_blend_point(p_rf, Vector2(1.0, 0))
	
	bs.add_blend_point(p_wf, Vector2(-0.5, 0.5))
	bs.add_blend_point(p_wf, Vector2(0.5, 0.5))
	bs.add_blend_point(p_rf, Vector2(-1.0, 1.0))
	bs.add_blend_point(p_rf, Vector2(1.0, 1.0))
	
	bs.add_blend_point(p_wb, Vector2(-0.5, -0.5))
	bs.add_blend_point(p_wb, Vector2(0.5, -0.5))
	bs.add_blend_point(p_wb, Vector2(-1.0, -1.0))
	bs.add_blend_point(p_wb, Vector2(1.0, -1.0))
	
	ResourceSaver.save(bs, "res://ch36_locomotion.tres")
	print("BlendSpace ch36_locomotion.tres guardado!")
	
	quit()

func _is_arm(path: String) -> bool:
	var l = path.to_lower()
	return ("arm" in l or "hand" in l or "shoulder" in l or "thumb" in l or "index" in l or "middle" in l or "ring" in l or "pinky" in l)

func _apply_aim_arms(src: Animation, idle: Animation) -> Animation:
	var out = Animation.new()
	out.length = src.length
	out.step = src.step
	
	# Copiar pistas que NO sean brazos
	for i in src.get_track_count():
		var p = str(src.track_get_path(i))
		if _is_arm(p):
			continue
		var t_idx = out.add_track(src.track_get_type(i))
		out.track_set_path(t_idx, NodePath(p))
		out.track_set_interpolation_type(t_idx, src.track_get_interpolation_type(i))
		out.track_set_interpolation_loop_wrap(t_idx, src.track_get_interpolation_loop_wrap(i))
		for k in src.track_get_key_count(i):
			out.track_insert_key(t_idx, src.track_get_key_time(i, k), src.track_get_key_value(i, k), src.track_get_key_transition(i, k))
			
	# Copiar brazos de idle
	for i in idle.get_track_count():
		var p = str(idle.track_get_path(i))
		if not _is_arm(p):
			continue
		var t_idx = out.add_track(idle.track_get_type(i))
		out.track_set_path(t_idx, NodePath(p))
		out.track_set_interpolation_type(t_idx, idle.track_get_interpolation_type(i))
		out.track_set_interpolation_loop_wrap(t_idx, idle.track_get_interpolation_loop_wrap(i))
		for k in idle.track_get_key_count(i):
			var t = idle.track_get_key_time(i, k)
			if t <= out.length:
				out.track_insert_key(t_idx, t, idle.track_get_key_value(i, k), idle.track_get_key_transition(i, k))
		out.track_insert_key(t_idx, out.length, idle.track_get_key_value(i, 0))
	return out

func _load_raw_anim(file_path: String) -> Animation:
	var doc = GLTFDocument.new()
	var state = GLTFState.new()
	doc.append_from_file(file_path, state)
	var scene = doc.generate_scene(state)
	var ap = scene.find_child("AnimationPlayer", true, false) as AnimationPlayer
	var a = ap.get_animation(ap.get_animation_list()[0]).duplicate()
	scene.queue_free()
	return a
