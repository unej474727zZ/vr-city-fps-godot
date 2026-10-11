@tool
extends SceneTree

func _init():
	var lib = load("res://combat_anims.res") as AnimationLibrary
	var idle = lib.get_animation("Idle")
	for t in idle.get_track_count():
		var p = String(idle.track_get_path(t))
		if p.ends_with(":Hips"):
			var q = idle.track_get_key_value(t, 0) as Quaternion
			print("Hips rot: ", q)
			print("Hips Basis Z: ", Basis(q).z)
			print("Hips Euler (deg): ", q.get_euler() * 180.0 / PI)
	quit()
