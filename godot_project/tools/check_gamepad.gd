@tool
extends SceneTree

func _init():
	var joypads = Input.get_connected_joypads()
	print("JOYPADS CONECTADOS: ", joypads.size())
	for id in joypads:
		print("ID: ", id)
		print("  Nombre: ", Input.get_joy_name(id))
		print("  GUID: ", Input.get_joy_guid(id))
		print("  Es reconocido: ", Input.is_joy_known(id))
	quit()
