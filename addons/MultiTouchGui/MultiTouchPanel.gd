## A GUI pad for single and multitouch input. 
extends Panel
class_name MultiTouchPanel

var cursor : ColorRect

## The current amount of touches received.
var touches : int

@export_group("Values")
## Multitouch input. Not intended to be directly edited. For single touch input use cursor_position.
@export var value : Array[Vector2]
## Set the values to output to range from 0.0 to 1.0. Disabling this sets the output value to the positon of the input inside of the pad.
@export var normalize_value : bool = true

@export_group("Single Touch")
## Turn on and off a visible cursor. Useful for visualizing single touch input. Use cursor_position for touch location when in single touch mode.
@export var force_single_touch : bool = false
## Change the color of the cursor
@export var cursor_color : Color = Color.DARK_BLUE
## Change the size of the cursor
@export var cursor_scale : float = 0.05
var cursor_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	value.resize(10)
	
	
	cursor = ColorRect.new()
	cursor.size = size * cursor_scale
	cursor.color = cursor_color
	add_child(cursor)
	cursor.visible = force_single_touch
	pass # Replace with function body.


func _gui_input(event):
	var event_pos_adjusted = event.position + global_position
	var inside = event_pos_adjusted.x > position.x and event_pos_adjusted.y > position.y and event_pos_adjusted.x < position.x + size.x and event_pos_adjusted.y < position.y + size.y
	
	if event is InputEventScreenTouch and event.pressed and inside:
		touches += 1
	elif event is InputEventScreenTouch and inside or !inside and event is InputEventScreenTouch:
		touches -= 1
	
	
	if event is InputEventScreenTouch and !event.pressed:
		replace(value, event.index, Vector2.ZERO)
	
	if force_single_touch:
		if event is InputEventScreenTouch and event.pressed and inside:
			
			cursor.position = event.position - (cursor.size/2)
			if normalize_value:
				cursor_position = Vector2(event.position.x  / size.x, event.position.y / size.y)
				cursor_position.y = 1.0 - cursor_position.y
			else:
				cursor_position = event.position 
		elif event is InputEventScreenDrag and inside:
			
			cursor.position = event.position - (cursor.size/2)
			if normalize_value:
				cursor_position = Vector2(event.position.x  / size.x, event.position.y / size.y)
				cursor_position.y = 1.0 - cursor_position.y
			else:
				cursor_position = event.position 
	else:
		if event is InputEventScreenTouch and event.pressed and inside:
			
			if normalize_value:
				var new_vec = event.position  / size
				new_vec.y = 1.0 - new_vec.y
				replace(value, event.index, new_vec)
			else:
				replace(value, event.index, event.position)
			
			
		elif event is InputEventScreenDrag and inside:
			
			if normalize_value:
				var new_vec = event.position / size
				new_vec.y = 1.0 - new_vec.y
				replace(value, event.index, new_vec)
			else:
				replace(value, event.index, event.position)


## Find the distance between two multitouch points. 
func distance(index_a : int, index_b : int):
	
	if value[index_a] and value[index_b]:
		
		return value[index_a].distance_to(value[index_b])
		
	



func replace(arr : Array, index : int, val):
	
	arr.insert(index, val)
	arr.remove_at(index + 1)
