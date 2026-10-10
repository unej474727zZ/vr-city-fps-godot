extends Label

func _ready() -> void:
	text = "Mando conectado. Presiona cualquier botón..."

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		var btn_name: String = ""
		match event.button_index:
			0: btn_name = " (A / Cruz)"
			1: btn_name = " (B / Círculo)"
			2: btn_name = " (X / Cuadrado)"
			3: btn_name = " (Y / Triángulo)"
			6: btn_name = " (L2 D-Input)"
			7: btn_name = " (R2 D-Input)"
			8: btn_name = " (R3 / Select)"
			9: btn_name = " (L1 / Left Shoulder)"
			10: btn_name = " (R1 / Right Shoulder)"
		text = "Botón: %d%s | Presionado: %s" % [event.button_index, btn_name, str(event.pressed)]
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.3:
		var axis_name: String = ""
		match event.axis:
			0: axis_name = " (Stick Izq X)"
			1: axis_name = " (Stick Izq Y)"
			2: axis_name = " (Stick Der X)"
			3: axis_name = " (Stick Der Y)"
			4: axis_name = " (Gatillo L2)"
			5: axis_name = " (Gatillo R2)"
		text = "Eje: %d%s | Valor: %.2f" % [event.axis, axis_name, event.axis_value]
