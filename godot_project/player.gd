class_name PlayerController
extends CharacterBody3D

@export var walk_speed: float = 2.8
@export var run_speed: float = 6.2
@export var jump_velocity: float = 5.2
@export var rotation_speed: float = 2.4
@export var gravity: float = 19.6

@onready var head: Node3D = $Head
@onready var anim_tree: AnimationTree = $SKM_UEFN_Mannequin/AnimationPlayer/AnimationTree
@onready var skeleton: Skeleton3D = $SKM_UEFN_Mannequin/SKM_UEFN_Mannequin/GeneralSkeleton
@onready var weapon: Node3D = find_child("Weapon", true, false)
@onready var head_bone: BoneAttachment3D = find_child("BoneAttachment3D", true, false)

var pitch: float = 0.0
var state_machine: AnimationNodeStateMachinePlayback
var weapon_base_pos: Vector3
var weapon_base_rot: Vector3
var recoil_offset: Vector3 = Vector3.ZERO
var recoil_target: Vector3 = Vector3.ZERO

func _ready() -> void:
	if anim_tree:
		anim_tree.active = true
		state_machine = anim_tree.get("parameters/StateMachine/playback")
	
	if weapon:
		weapon_base_pos = weapon.position
		weapon_base_rot = weapon.rotation

func _physics_process(delta: float) -> void:
	# 1. Rotación del cuerpo (Horizontal / Yaw) con Stick Derecho
	var rot_input = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")
	rotate_y(rot_input * rotation_speed * delta)

	# 2. Inclinación de la cabeza (Vertical / Pitch) con Stick Derecho
	var rot_input_y = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	pitch += rot_input_y * rotation_speed * delta
	pitch = clamp(pitch, -1.25, 1.25)
	
	if head:
		# Sincronizar posición con el hueso de la cabeza para el balanceo al caminar
		if head_bone:
			var target_pos = head_bone.global_position
			# Red de seguridad: la cabeza nunca puede alejarse verticalmente del cuerpo
			if abs(target_pos.y - global_position.y) > 2.0:
				target_pos.y = global_position.y + 1.5
			head.global_position = target_pos
		# Rotación local pura: evita volteos extraños o rotación dentro del pecho
		head.rotation.x = pitch
		head.rotation.y = 0.0
		head.rotation.z = 0.0

	# 3. Movimiento con Stick Izquierdo
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_vector: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var is_sprinting: bool = Input.is_action_pressed("sprint")
	var current_speed: float = run_speed if is_sprinting else walk_speed
	
	if move_vector.length() > 0.05:
		velocity.x = move_vector.x * current_speed
		velocity.z = move_vector.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, walk_speed * 4.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, walk_speed * 4.0 * delta)

	# 4. Gravedad y Salto (SOLO permitido si está tocando el suelo)
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		# Reseteo al tocar el suelo: evita acumulaciones de impulso
		if velocity.y < 0.0:
			velocity.y = -0.5
		
		# Salto: Requiere estrictamente is_on_floor()
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
			if state_machine:
				state_machine.travel("Combat_Jump")

	# 5. Disparo (R1 o R2 o Click)
	if Input.is_action_just_pressed("shoot"):
		_execute_shoot()

	# 6. Animaciones de Locomoción
	if anim_tree:
		var blend_scale: float = 1.0 if is_sprinting else 0.5
		var blend_pos: Vector2 = Vector2(input_dir.x, -input_dir.y) * blend_scale
		anim_tree.set("parameters/StateMachine/Locomotion/blend_position", blend_pos)
		
		if is_on_floor() and velocity.y <= 0.0 and state_machine and state_machine.get_current_node() != "Locomotion":
			state_machine.travel("Locomotion")

	# 7. Retroceso Procedural del Arma (Recoil)
	if weapon:
		recoil_target = recoil_target.lerp(Vector3.ZERO, delta * 12.0)
		recoil_offset = recoil_offset.lerp(recoil_target, delta * 25.0)
		weapon.position = weapon_base_pos + recoil_offset

	move_and_slide()

func _execute_shoot() -> void:
	# Disparar animación en AnimationTree usando el nodo OneShot
	if anim_tree:
		anim_tree.set("parameters/ShootOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	# Efecto de retroceso en el arma (kick hacia atrás en Z y arriba en Y)
	recoil_target = Vector3(0.0, 0.04, -0.08)
