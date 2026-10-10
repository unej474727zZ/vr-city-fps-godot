@tool
extends EditorScript

func _run():
	print("--- INYECTANDO LOCOMOCIÓN EN LA ESCENA ACTIVA ---")
	
	var root = EditorInterface.get_edited_scene_root()
	if not root:
		print("❌ Error: No hay ninguna escena abierta.")
		return
		
	var tree = root.find_child("AnimationTree", true, false)
	if not tree:
		print("❌ Error: No se encontró el nodo AnimationTree en la escena.")
		return
		
	var blend_tree = tree.tree_root
	var state_machine = blend_tree.get_node("StateMachine")
	
	# Borrar nodos viejos
	var old_nodes = ["Combat_Idle", "Combat_Walk", "Combat_Walk_B", "Combat_Run"]
	for n in old_nodes:
		if state_machine.has_node(n):
			state_machine.remove_node(n)
			
	# Cargar y añadir nuestro blendspace
	var locomotion = load("res://locomotion_blendspace.tres")
	if not locomotion:
		print("❌ Primero debes ejecutar setup_blendspace.gd para crear el archivo!")
		return
		
	state_machine.add_node("Locomotion", locomotion)
	state_machine.set_node_position("Locomotion", Vector2(400, 100))
	
	# Transiciones
	var t1 = AnimationNodeStateMachineTransition.new()
	t1.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
	state_machine.add_transition("Start", "Locomotion", t1)
	
	var t2 = AnimationNodeStateMachineTransition.new()
	state_machine.add_transition("Locomotion", "Combat_Jump", t2)
	
	var t3 = AnimationNodeStateMachineTransition.new()
	t3.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
	state_machine.add_transition("Combat_Jump", "Locomotion", t3)
	
	print("✅ ¡INYECCIÓN EXITOSA! Todo está conectado en vivo.")
