## Experimental currently, two finger tap to clear text.
extends LineEdit
class_name MultiTouchLineEdit



func _gui_input(event):
	var event_pos_adjusted = event.position + global_position
	var inside = event_pos_adjusted.x > position.x and event_pos_adjusted.y > position.y and event_pos_adjusted.x < position.x + size.x and event_pos_adjusted.y < position.y + size.y
	
	
	if event is InputEventScreenTouch and event.pressed and inside:
		
		#ProjectSettings.set_setting("input_devices/pointing/emulate_mouse_from_touch", true)
		DisplayServer.virtual_keyboard_show("")
		grab_focus()
		caret_column = len(text)
		
	
	if !inside:
		release_focus()
		DisplayServer.virtual_keyboard_hide()
	
	
	if event is InputEventScreenTouch and inside and event.index >= 1:
		clear()
		
		
