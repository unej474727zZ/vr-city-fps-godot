#ifndef VR_PLAYER_H
#define VR_PLAYER_H

#include <godot_cpp/classes/animation_node_state_machine_playback.hpp>
#include <godot_cpp/classes/animation_player.hpp>
#include <godot_cpp/classes/animation_tree.hpp>
#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/node3d.hpp>

namespace godot {

class VRPlayer : public CharacterBody3D {
  GDCLASS(VRPlayer, CharacterBody3D)

private:
  float walk_speed = 5.0f;
  float run_speed = 10.0f;
  float rotation_speed = 3.0f;
  float pitch = 0.0f;
  Node3D *head = nullptr;
  AnimationPlayer *anim_player = nullptr;
  AnimationTree *anim_tree = nullptr;
  Ref<AnimationNodeStateMachinePlayback> state_machine;
  Node3D *weapon = nullptr;

  String current_anim = "";
  float shoot_blend = 0.0f;
  float shoot_timer = 0.0f;

  // Sistema de Retroceso (Recoil)
  Vector3 recoil_offset;
  Vector3 recoil_target;
  Transform3D weapon_base_transform;
  float recoil_recovery_speed = 15.0f;
  float recoil_kick_speed = 30.0f;

protected:
  static void _bind_methods();

public:
  VRPlayer();
  ~VRPlayer();

  void _ready() override;
  void _physics_process(double delta) override;
};

} // namespace godot

#endif
