@tool
extends EditorScript

func _run():
	var lib = load("res://combat_anims.res")
	if lib:
		var anim = lib.get_animation("Shoot")
		if anim:
			print("--- PISTAS DE SHOOT ---")
			for i in range(min(5, anim.get_track_count())):
				print(anim.track_get_path(i))
		else:
			print("No se encontró la animación Shoot")
	else:
		print("No se cargó la librería")
