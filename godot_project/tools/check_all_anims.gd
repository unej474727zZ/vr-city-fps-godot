@tool
extends SceneTree

func _init():
	var lib = load("res://combat_anims.res") as AnimationLibrary
	for anim_name in lib.get_animation_list():
		var anim = lib.get_animation(anim_name)
		print("=== Animation: ", anim_name, " ===")
		var pos_tracks = 0
		var max_pos_val = 0.0
		for t in range(anim.get_track_count()):
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				pos_tracks += 1
				var p = anim.track_get_path(t)
				if anim.track_get_key_count(t) > 0:
					var v: Vector3 = anim.track_get_key_value(t, 0)
					if v.length() > max_pos_val:
						max_pos_val = v.length()
					if v.length() > 2.0:
						print("  HIGH POS TRACK: ", p, " = ", v)
		print("  Total pos tracks: ", pos_tracks, " Max pos mag: ", max_pos_val)
	quit()
