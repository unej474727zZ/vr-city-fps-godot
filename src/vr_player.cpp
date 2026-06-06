#include "vr_player.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <algorithm>

using namespace godot;

void VRPlayer::_bind_methods() {
    // Aquí podemos exponer variables a Godot si lo necesitamos
}

VRPlayer::VRPlayer() {
}

VRPlayer::~VRPlayer() {
}

void VRPlayer::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) return;
    head = get_node<Node3D>("Head");
}

void VRPlayer::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    Input* input = Input::get_singleton();

    // Rotación del cuerpo con el Joystick Derecho (Izquierda/Derecha)
    float rot_input = input->get_action_strength("look_left") - input->get_action_strength("look_right");
    rotate_y(rot_input * rotation_speed * delta);

    // Inclinación de la cabeza (Arriba/Abajo)
    float rot_input_y = input->get_action_strength("look_up") - input->get_action_strength("look_down");
    pitch += rot_input_y * rotation_speed * delta;
    pitch = std::clamp(pitch, -1.5f, 1.5f); // Limitar para no romper el cuello

    if (head) {
        Vector3 rot = head->get_rotation();
        rot.x = pitch;
        head->set_rotation(rot);
    }

    // Movimiento con el Joystick Izquierdo
    Vector2 input_dir = input->get_vector("move_left", "move_right", "move_forward", "move_backward");
    Vector3 direction = get_transform().basis.xform(Vector3(input_dir.x, 0, input_dir.y)).normalized();

    Vector3 velocity = get_velocity();
    if (direction.length() > 0.0f) {
        velocity.x = direction.x * speed;
        velocity.z = direction.z * speed;
    } else {
        velocity.x = 0.0f;
        velocity.z = 0.0f;
    }

    // Gravedad y Salto
    if (!is_on_floor()) {
        velocity.y -= 9.8f * delta;
    } else {
        if (input->is_action_just_pressed("jump")) {
            velocity.y = 5.0f; // Fuerza del salto
        }
    }

    // Disparo
    if (input->is_action_just_pressed("shoot")) {
        UtilityFunctions::print("¡PUM! Disparo ejecutado.");
        // Aquí conectaremos las balas y el sonido más adelante
    }

    set_velocity(velocity);
    move_and_slide();
}
