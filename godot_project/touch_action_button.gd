extends Button

## Botón táctil que dispara acciones en Input (ej: jump, sprint, shoot)

@export var action_name: String = ""

func _ready() -> void:
	button_down.connect(_on_down)
	button_up.connect(_on_up)

func _on_down() -> void:
	if action_name != "":
		Input.action_press(action_name)

func _on_up() -> void:
	if action_name != "":
		Input.action_release(action_name)
