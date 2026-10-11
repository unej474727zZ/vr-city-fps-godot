@tool
extends SceneTree

func _init():
	var lib = load("res://combat_anims.res") as AnimationLibrary
	var shoot = lib.get_animation("Shoot")
	for t in range(22):
		var path = shoot.track_get_path(t)
		var type = shoot.track_get_type(t)
		var key_count = shoot.track_get_key_count(t)
		var first_val = ""
		if key_count > 0:
			first_val = str(shoot.track_get_key_value(t, 0))
		print("Track ", t, ": ", path, " (type ", type, ", keys ", key_count, ") val0: ", first_val)
	quit()
