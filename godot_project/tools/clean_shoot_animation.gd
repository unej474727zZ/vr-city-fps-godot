@tool
extends SceneTree

func _init():
	print("--- CLEANING SHOOT ANIMATION IN COMBAT_ANIMS.RES ---")
	var lib = load("res://combat_anims.res") as AnimationLibrary
	if not lib:
		printerr("Failed to load combat_anims.res")
		quit()
		return
	
	var shoot = lib.get_animation("Shoot")
	if not shoot:
		printerr("Animation 'Shoot' not found")
		quit()
		return
	
	print("Initial track count in Shoot: ", shoot.get_track_count())
	var removed = 0
	# Iterate backwards to safely remove tracks
	for t in range(shoot.get_track_count() - 1, -1, -1):
		if shoot.track_get_type(t) == Animation.TYPE_POSITION_3D:
			shoot.remove_track(t)
			removed += 1
	
	print("Removed ", removed, " position tracks.")
	print("Remaining track count in Shoot: ", shoot.get_track_count())
	
	var err = ResourceSaver.save(lib, "res://combat_anims.res")
	if err == OK:
		print("Successfully saved cleaned combat_anims.res!")
	else:
		printerr("Failed to save combat_anims.res: ", err)
	quit()
