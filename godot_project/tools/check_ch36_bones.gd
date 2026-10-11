@tool
extends SceneTree

func _init():
	var doc = GLTFDocument.new()
	var state = GLTFState.new()
	doc.append_from_file("res://assets/animations/Rifleidle.glb", state)
	var scene = doc.generate_scene(state)
	var skel = scene.find_child("Skeleton3D", true, false) as Skeleton3D
	print("Skeleton bone count: ", skel.get_bone_count())
	print("Head bone idx: ", skel.find_bone("mixamorig1_Head"), " or mixamorig_Head: ", skel.find_bone("mixamorig_Head"))
	print("RightHand bone idx: ", skel.find_bone("mixamorig1_RightHand"), " or mixamorig_RightHand: ", skel.find_bone("mixamorig_RightHand"))
	print("Hips bone idx: ", skel.find_bone("mixamorig1_Hips"))
	print("Head bone name: ", skel.get_bone_name(skel.find_bone("mixamorig1_Head")))
	print("RightHand bone name: ", skel.get_bone_name(skel.find_bone("mixamorig1_RightHand")))
	print("Head global pos Y: ", skel.get_bone_global_pose(skel.find_bone("mixamorig1_Head")).origin.y)
	scene.queue_free()
	quit()
