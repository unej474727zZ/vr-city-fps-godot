@tool
extends SceneTree

func _init():
	var packed = load("res://assets/animations/Rifleidle.glb") as PackedScene
	var scene = packed.instantiate()
	var ap = scene.find_child("AnimationPlayer", true, false) as AnimationPlayer
	var arm = scene.find_child("Armature", true, false) as Node3D
	var skel = scene.find_child("Skeleton3D", true, false) as Skeleton3D
	var head = skel.find_bone("mixamorig1_Head")
	var rh = skel.find_bone("mixamorig1_RightHand")
	
	ap.play(ap.get_animation_list()[0])
	ap.advance(0.1)
	
	var head_tf = arm.transform * skel.get_bone_global_pose(head)
	var rh_tf = arm.transform * skel.get_bone_global_pose(rh)
	
	print("Head forward (basis.z): ", head_tf.basis.z)
	print("RightHand forward (basis.z): ", rh_tf.basis.z)
	scene.queue_free()
	quit()
