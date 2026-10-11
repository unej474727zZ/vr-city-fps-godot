@tool
extends SceneTree

func _init():
	var doc = GLTFDocument.new()
	var state = GLTFState.new()
	doc.append_from_file("res://assets/animations/Rifleidle.glb", state)
	var scene = doc.generate_scene(state)
	var arm = scene.find_child("Armature", true, false) as Node3D
	var skel = scene.find_child("Skeleton3D", true, false) as Skeleton3D
	print("Armature transform: ", arm.transform)
	print("Skeleton3D transform: ", skel.transform)
	var ap = scene.find_child("AnimationPlayer", true, false) as AnimationPlayer
	print("AP root_node: ", ap.root_node)
	var anim = ap.get_animation(ap.get_animation_list()[0])
	ap.play(ap.get_animation_list()[0])
	ap.advance(0.1)
	var head = skel.find_bone("mixamorig1_Head")
	print("Playing anim Head global pos: ", skel.to_global(skel.get_bone_global_pose(head).origin))
	var rh = skel.find_bone("mixamorig1_RightHand")
	print("Playing anim RightHand global pos: ", skel.to_global(skel.get_bone_global_pose(rh).origin))
	var hips = skel.find_bone("mixamorig1_Hips")
	print("Playing anim Hips global pos: ", skel.to_global(skel.get_bone_global_pose(hips).origin))
	scene.queue_free()
	quit()
