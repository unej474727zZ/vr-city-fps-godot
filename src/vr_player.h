#ifndef VR_PLAYER_H
#define VR_PLAYER_H

#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/input.hpp>

namespace godot {

class VRPlayer : public CharacterBody3D {
    GDCLASS(VRPlayer, CharacterBody3D)

private:
    float speed = 5.0f;
    float rotation_speed = 3.0f;
    float pitch = 0.0f;
    Node3D* head = nullptr;

protected:
    static void _bind_methods();

public:
    VRPlayer();
    ~VRPlayer();

    void _ready() override;
    void _physics_process(double delta) override;
};

}

#endif
