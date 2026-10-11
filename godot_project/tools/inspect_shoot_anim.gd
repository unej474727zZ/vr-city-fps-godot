@tool
extends SceneTree

func _init():
	var lib = load("res://combat_anims.res") as AnimationLibrary
	if lib:
		print("Animations in Combat:")
		for anim_name in lib.get_animation_list():
			print(" - ", anim_name)
		var shoot = lib.get_animation("Shoot")
		if not shoot:
			shoot = lib.get_animation("Combat/Shoot")
		if shoot:
			print("\n--- TRACKS OF SHOOT ANIMATION ---")
			print("Length: ", shoot.length)
			for t in range(shoot.get_track_count()):
				var path = shoot.track_get_path(t)
				var type = shoot.track_get_type(t)
				var key_count = shoot.track_get_key_count(t)
				var first_val = ""
				if key_count > 0:
					first_val = str(shoot.track_get_key_value(t, 0))
				print("Track ", t, ": ", path, " (type ", type, ", keys ", key_count, ") val0: ", first_val)
	quit()
