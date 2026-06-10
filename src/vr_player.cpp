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
    head = Object::cast_to<Node3D>(find_child("Head", true, false));
    anim_player = Object::cast_to<AnimationPlayer>(find_child("AnimationPlayer", true, false));
    weapon = Object::cast_to<Node3D>(find_child("Sketchfab_Scene", true, false));
    
    if (weapon) {
        weapon_base_transform = weapon->get_transform();
    }
}

void VRPlayer::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    Input* input = Input::get_singleton();

    // Rotación del cuerpo con el Joystick Derecho (Izquierda/Derecha)
    float rot_input = input->get_action_strength("look_left") - input->get_action_strength("look_right");
    rotate_y(rot_input * rotation_speed * delta);

    // Inclinación de la cabeza (Arriba/Abajo)
    float rot_input_y = input->get_action_strength("look_up") - input->get_action_strength("look_down");
    pitch -= rot_input_y * rotation_speed * delta;
    pitch = std::clamp(pitch, -1.5f, 1.5f); // Limitar para no romper el cuello

    if (head) {
        Vector3 rot = head->get_rotation();
        rot.x = pitch;
        head->set_rotation(rot);
    }

    // Movimiento con el Joystick Izquierdo
    Vector2 input_dir = input->get_vector("move_left", "move_right", "move_forward", "move_backward");
    Vector3 direction = get_transform().basis.xform(Vector3(input_dir.x, 0, input_dir.y)).normalized();

    float current_speed = walk_speed;
    // L2 gatillo izquierdo
    bool is_sprinting = input->is_action_pressed("sprint") || input->get_joy_axis(0, godot::JOY_AXIS_TRIGGER_LEFT) > 0.5f;
    if (is_sprinting) {
        current_speed = run_speed;
    }

    Vector3 velocity = get_velocity();
    if (direction.length() > 0.0f) {
        velocity.x = direction.x * current_speed;
        velocity.z = direction.z * current_speed;
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
    bool is_shooting = false;
    if (input->is_action_just_pressed("shoot")) {
        UtilityFunctions::print("¡PUM! Disparo ejecutado.");
        is_shooting = true;
    }
    
    // Control de Animaciones (Solo Cuerpo)
    if (anim_player) {
        String target_anim = "Combat/Idle"; // Por defecto
        
        if (!is_on_floor()) {
            target_anim = "Combat/Jump";
        } else if (direction.length() > 0.0f) {
            // Chequear si vamos hacia atrás
            Vector3 forward = -get_transform().basis.get_column(2);
            if (direction.dot(forward) < -0.1f) {
                target_anim = "Combat/Walk_B";
            } else if (is_sprinting) {
                target_anim = "Combat/Run";
            } else {
                target_anim = "Combat/Walk";
            }
        }
        
        // Reproducir la animación solo si cambió
        if (target_anim != current_anim) {
            anim_player->play(target_anim, 0.2f); // 0.2 segundos de transición (Blend)
            current_anim = target_anim;
        }
    }
    
    // Sistema de Retroceso (Recoil Procedural) en el Arma
    if (weapon) {
        if (is_shooting) {
            // Dar una patada hacia atrás (Z) y un poco hacia arriba (Y)
            // Nota: Los ejes pueden variar dependiendo del modelo, ajustaremos si es necesario.
            recoil_target = Vector3(0.0f, 0.05f, -0.15f); 
        }
        
        // Interpolar el target hacia 0 (recuperación)
        recoil_target = recoil_target.lerp(Vector3(), (float)delta * recoil_recovery_speed);
        
        // Interpolar el offset actual hacia el target (velocidad de la patada)
        recoil_offset = recoil_offset.lerp(recoil_target, (float)delta * recoil_kick_speed);
        
        // Aplicar la transformación base + el offset local
        Transform3D current_transform = weapon_base_transform;
        current_transform.origin += current_transform.basis.xform(recoil_offset);
        weapon->set_transform(current_transform);
    }

    set_velocity(velocity);
    move_and_slide();
}
