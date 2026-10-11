@tool
extends SceneTree

func _init():
	var lib = load("res://combat_anims.res") as AnimationLibrary
	print("Anims in 7b7e6d7: ", lib.get_animation_list().size())
	for a in ["Idle", "Walk_F", "Run_F", "Jump", "Shoot"]:
		var anim = lib.get_animation(a)
		print(a, " -> length: ", anim.length, " loop: ", anim.loop_mode, " tracks: ", anim.get_track_count())
		
	var skel_scene = load("res://assets/models/player/GaspFix/Characters/UEFN_Mannequin/Meshes/SKM_UEFN_Mannequin.FBX").instantiate()
	root.add_child(skel_scene)
	var ap = skel_scene.find_child("AnimationPlayer", true, false) as AnimationPlayer
	ap.add_animation_library("Combat", lib)
	var inner_node = skel_scene.get_node("SKM_UEFN_Mannequin")
	ap.root_node = ap.get_path_to(inner_node)
	
	var skel = skel_scene.find_child("GeneralSkeleton", true, false) as Skeleton3D
	var r_hand = skel.find_bone("RightHand")
	var head = skel.find_bone("Head")
	var l_foot = skel.find_bone("LeftFoot")
	
	ap.play("Combat/Idle")
	ap.advance(0.1)
	print("Idle Head pos: ", skel.get_bone_global_pose(head).origin)
	print("Idle RightHand pos: ", skel.get_bone_global_pose(r_hand).origin)
	print("Idle LeftFoot pos: ", skel.get_bone_global_pose(l_foot).origin)
	
	ap.play("Combat/Run_F")
	ap.advance(0.3)
	print("Run_F LeftFoot pos: ", skel.get_bone_global_pose(l_foot).origin)
	
	skel_scene.queue_free()
	quit()
