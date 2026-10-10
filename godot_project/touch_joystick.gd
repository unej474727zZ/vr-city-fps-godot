class_name MobileVirtualJoystick
extends Control

## Virtual joystick touchscreen control inspired by mobile shooters (like accionCity)

signal joystick_updated(output: Vector2)
signal joystick_released()

@export var clampzone_size: float = 75.0
@export var deadzone_size: float = 10.0
@export var joystick_mode: int = 0 # 0: Fijo, 1: Dinámico

var _touch_index: int = -1
var _center_pos: Vector2 = Vector2.ZERO
var _current_vector: Vector2 = Vector2.ZERO

@onready var _base: Control = $Base
@onready var _tip: Control = $Base/Tip

func _ready() -> void:
	_center_pos = _base.size / 2.0
	_reset_tip()

func _reset_tip() -> void:
	_current_vector = Vector2.ZERO
	_tip.position = _base.size / 2.0 - _tip.size / 2.0
	_send_input(Vector2.ZERO)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and _touch_index == -1:
			_touch_index = event.index
			_update_stick(event.position)
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_reset_tip()
			joystick_released.emit()

	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_stick(event.position)

func _update_stick(target_pos: Vector2) -> void:
	var diff: Vector2 = target_pos - _center_pos
	var dist: float = diff.length()
	
	if dist > clampzone_size:
		diff = diff.normalized() * clampzone_size
	
	_tip.position = (_base.size / 2.0 - _tip.size / 2.0) + diff
	
	if dist < deadzone_size:
		_current_vector = Vector2.ZERO
	else:
		var normalized_dist: float = (dist - deadzone_size) / (clampzone_size - deadzone_size)
		_current_vector = diff.normalized() * clampzone_size
		_current_vector = _current_vector / clampzone_size
		_current_vector *= normalized_dist
	
	_send_input(_current_vector)

func _send_input(vec: Vector2) -> void:
	joystick_updated.emit(vec)
	
	# Inyectar acciones estándar de Godot para mover el personaje
	var deadzone := 0.15
	_set_action("move_right", vec.x > deadzone, max(0.0, vec.x))
	_set_action("move_left", vec.x < -deadzone, max(0.0, -vec.x))
	_set_action("move_backward", vec.y > deadzone, max(0.0, vec.y))
	_set_action("move_forward", vec.y < -deadzone, max(0.0, -vec.y))

func _set_action(action_name: String, pressed: bool, strength: float) -> void:
	if pressed:
		Input.action_press(action_name, strength)
	else:
		Input.action_release(action_name)
