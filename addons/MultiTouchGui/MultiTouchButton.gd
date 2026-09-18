extends Button
class_name MultiTouchButton
@export_custom(PROPERTY_HINT_INPUT_NAME, &"show_builtin") var input_to_do : StringName = ""

func _gui_input(event):
	var event_pos_adjusted : Vector2
	var inside : bool
	if event.get(&"position"):
		event_pos_adjusted = event.position + global_position
		inside = event_pos_adjusted.x > position.x and event_pos_adjusted.y > position.y and event_pos_adjusted.x < position.x + size.x and event_pos_adjusted.y < position.y + size.y
	
	if event is InputEventScreenTouch and event.pressed and inside:
		
		if toggle_mode:
			toggled.emit()
			button_pressed = true
			Input.action_press(input_to_do)
		else:
			pressed.emit()
			button_down.emit()
			Input.action_press(input_to_do)
			
		
		
		
		
	elif (event is InputEventScreenTouch and inside) or (event is InputEventScreenTouch and !event.pressed and !inside):
		button_up.emit()
		button_pressed = false
		Input.action_release(input_to_do)
	
	
