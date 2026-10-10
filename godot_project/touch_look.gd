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
	mouse_filter = Control.MOUSE_FILTER_PASS
	if has_node(player_node):
		_player = get_node(player_node) as CharacterBody3D

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1:
			# Ignorar toques en la esquina inferior izquierda (zona del joystick de movimiento)
			if event.position.x < 320.0 and event.position.y > (get_viewport_rect().size.y - 320.0):
				return
			_touch_index = event.index
			_last_pos = event.position
			_touch_start_time = Time.get_ticks_msec() / 1000.0
			_touch_moved_dist = 0.0
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1

	elif event is InputEventScreenDrag and event.index == _touch_index:
		var delta: Vector2 = event.position - _last_pos
		_last_pos = event.position
		_touch_moved_dist += delta.length()
		if _player:
			_apply_look(delta)

func _apply_look(relative: Vector2) -> void:
	# Rotar cuerpo horizontalmente (Yaw)
	_player.rotate_y(-relative.x * sensitivity)
	
	# Inyectar una pequeña inclinación vertical (Pitch) a las acciones de Godot
	# Reducido el factor a 0.01 para evitar que la cámara se descontrole
	var strength: float = clamp(abs(relative.y) * 0.01, 0.0, 1.0)
	if relative.y < 0.0:
		Input.action_press("look_up", strength)
	elif relative.y > 0.0:
		Input.action_press("look_down", strength)
	
	await get_tree().process_frame
	Input.action_release("look_up")
	Input.action_release("look_down")

func _trigger_shoot() -> void:
	# Solo el botón FIRE dispara para evitar disparos accidentales al rotar la vista
	pass
