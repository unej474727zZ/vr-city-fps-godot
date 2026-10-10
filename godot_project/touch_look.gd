extends Control

## Touch look swipe zone (lado derecho de la pantalla, como accionCity / shooters móviles)

@export var player_node: NodePath
@export var sensitivity: float = 0.004

var _touch_index: int = -1
var _last_pos: Vector2 = Vector2.ZERO
var _player: CharacterBody3D

# Tap to shoot (sistema accionCity: tap rápido = disparo, arrastrar = rotar cámara)
var _touch_start_time: float = 0.0
var _touch_moved_dist: float = 0.0

func _ready() -> void:
	if has_node(player_node):
		_player = get_node(player_node) as CharacterBody3D

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1:
			_touch_index = event.index
			_last_pos = event.position
			_touch_start_time = Time.get_ticks_msec() / 1000.0
			_touch_moved_dist = 0.0
		elif not event.pressed and event.index == _touch_index:
			var duration = (Time.get_ticks_msec() / 1000.0) - _touch_start_time
			if _touch_moved_dist < 15.0 and duration < 0.28:
				# Toque limpio en pantalla = Disparar (estilo accionCity)
				_trigger_shoot()
			_touch_index = -1

	elif event is InputEventScreenDrag and event.index == _touch_index:
		var delta: Vector2 = event.position - _last_pos
		_last_pos = event.position
		_touch_moved_dist += delta.length()
		
		# Aplicar rotación al jugador si está conectado
		if _player:
			_apply_look(delta)

func _apply_look(relative: Vector2) -> void:
	# Rotación horizontal del cuerpo del jugador (Yaw)
	_player.rotate_y(-relative.x * sensitivity)
	
	# Pitch vertical en Head
	var head = _player.find_child("Head", true, false) as Node3D
	if head:
		var current_rot = head.rotation
		current_rot.x -= relative.y * sensitivity
		current_rot.x = clamp(current_rot.x, -1.35, 1.35)
		head.rotation = current_rot

func _trigger_shoot() -> void:
	Input.action_press("shoot")
	await get_tree().create_timer(0.08).timeout
	Input.action_release("shoot")
