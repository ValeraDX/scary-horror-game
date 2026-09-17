extends HSlider
class_name MultiTouchHSlider

## Adds increases the y input that selects the slider.
@export var padding = 0.1


func _gui_input(event):
	var event_pos_adjusted = event.position + global_position
	var inside = event_pos_adjusted.x > position.x and event_pos_adjusted.y > position.y - position.y * (size.y * (1.0 - padding)) and event_pos_adjusted.x < position.x + size.x and event_pos_adjusted.y < position.y + size.y * (1.0 + padding)
	if event is InputEventScreenTouch and event.pressed and inside or event is InputEventScreenDrag and inside:
		
		value =  (event.position.x / size.x) * max_value
	
