@tool
extends SceneTree

func _init():
	print("--- PROBANDO INSTANCIACIÓN DIRECTA DE RIFLEIDLE.GLB ---")
	var packed = load("res://assets/animations/Rifleidle.glb") as PackedScene
	var scene = packed.instantiate()
	root.add_child(scene)
	
	var ap = scene.find_child("AnimationPlayer", true, false) as AnimationPlayer
	var skel = scene.find_child("Skeleton3D", true, false) as Skeleton3D
	var head = skel.find_bone("mixamorig1_Head")
	var rh = skel.find_bone("mixamorig1_RightHand")
	
	# Create BoneAttachments
	var ba_head = BoneAttachment3D.new()
	ba_head.bone_name = "mixamorig1_Head"
	skel.add_child(ba_head)
	
	var ba_rh = BoneAttachment3D.new()
	ba_rh.bone_name = "mixamorig1_RightHand"
	skel.add_child(ba_rh)
	
	ap.play(ap.get_animation_list()[0])
	ap.advance(0.1)
	
	print("Head global position: ", ba_head.global_position)
	print("RightHand global position: ", ba_rh.global_position)
	print("Head height Y: ", ba_head.global_position.y)
	
	scene.queue_free()
	quit()
