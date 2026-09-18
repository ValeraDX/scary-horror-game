extends Button
class_name MultiTouchButton
@export_custom(PROPERTY_HINT_INPUT_NAME, &"show_builtin") var input_to_do : StringName = ""

func _gui_input(event) -> void:
	var event_pos_adjusted : Vector2
	var inside : bool = false
	var truepos : Vector2 = position
	if event.get(&"position"):
		event_pos_adjusted = event.position + global_position
		if !offset_transform_visual_only:
			truepos += offset_transform_position
			truepos += offset_transform_position_ratio * size
		inside = event_pos_adjusted.x > truepos.x and event_pos_adjusted.y > truepos.y and event_pos_adjusted.x < truepos.x + size.x and event_pos_adjusted.y < truepos.y + size.y
	## right now the things above do not account for offset scale or anything but im tired	
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
	
	
