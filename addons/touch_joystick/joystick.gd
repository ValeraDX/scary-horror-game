@tool
@icon("res://addons/touch_joystick/joystick.png")

extends Node2D

signal direction

@export_group("Base Params")
@export var base_color : Color:
	set(value):
		queue_redraw()
		base_color = value

@export var size: float = 32:
	set(value):
		size = value
		queue_redraw()

@export_range(2,6,0.1) var knob_ratio: float = 4:
	set(value):
		knob_ratio = value
		queue_redraw()

@export_group("Input Actions")
@export var left: StringName = ""
@export var right: StringName = ""
@export var up: StringName = ""
@export var down: StringName = ""

var _shall_process: bool = false
var knob_position: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if (event is  InputEventScreenTouch):
		var touch: InputEventScreenTouch = event as InputEventScreenTouch
		if (((touch.position - position)/size).length() < 1):
			_shall_process = true
		_process_input(event, touch.position)

	if (event is InputEventScreenDrag):
		var drag: InputEventScreenDrag = event as InputEventScreenDrag
		_process_input(event, drag.position)
	#if (event is InputEventScreenTouch):

func _ready() -> void:
	direction.connect(_on_direction)

func _process_input(event: InputEvent, pos: Vector2) -> void:
	if (not _shall_process): return

	var knob_pos = pos - position
	if (event.is_released() and (event is InputEventScreenTouch and not event.is_pressed())):
		knob_position = Vector2.ZERO
		direction.emit(Vector2.ZERO)
		queue_redraw()
		_shall_process = false
		return;

	var _direction_vector:Vector2 = (knob_pos/size).normalized()
	knob_position = knob_pos.limit_length(size)
	direction.emit(_direction_vector)
	queue_redraw()

func _on_direction(dir: Vector2) -> void :
	# Horizontal movement
	if dir.x < 0:
		Input.action_press(left, abs(dir.x))
		Input.action_release(right)
	elif dir.x > 0:
		Input.action_press(right, abs(dir.x))
		Input.action_release(left)
	else:
		Input.action_release(left)
		Input.action_release(right)

	# Vertical movement
	if dir.y < 0:
		Input.action_press(up, abs(dir.y))
		Input.action_release(down)
	elif dir.y > 0:
		Input.action_press(down, abs(dir.y))
		Input.action_release(up)
	else:
		Input.action_release(up)
		Input.action_release(down)


func _draw() -> void:
	var center: Vector2 = Vector2(0,0)
	var radius:float = size
	var color: Color = Color(base_color, 0.25)
	draw_circle(center, radius, color, false, 2, true)
	draw_circle(center, radius, color, true, -1, true)
	draw_circle(knob_position, radius/knob_ratio, color, true, -1, true)
