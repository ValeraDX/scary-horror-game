extends VSlider
class_name MultiTouchVSlider

func _gui_input(event):
	var event_pos_adjusted = event.position + global_position
	var inside = event_pos_adjusted.x > position.x and event_pos_adjusted.y > position.y and event_pos_adjusted.x < position.x + size.x and event_pos_adjusted.y < position.y + size.y
	if event is InputEventScreenTouch and event.pressed and inside or event is InputEventScreenDrag and inside:
		
		value = (1 - event.position.y / size.y) * max_value
	
	
