@tool
extends SceneTree

func _init():
	print("Checking disparo.res...")
	var disp = load("res://disparo.res")
	print("Type of disparo.res: ", disp.get_class() if disp else "null")
	if disp is Animation:
		print("It is an Animation of length: ", disp.length, " tracks: ", disp.get_track_count())
		for t in range(disp.get_track_count()):
			print("  Track ", t, ": ", disp.track_get_path(t), " type: ", disp.track_get_type(t))
	elif disp is AnimationLibrary:
		print("It is an AnimationLibrary")
	quit()
