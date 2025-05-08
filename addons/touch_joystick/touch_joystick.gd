@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("TouchScreenJoystick", "Node2D", preload("res://addons/touch_joystick/joystick.gd"), preload("res://addons/touch_joystick/joystick.png"))
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	remove_custom_type("TouchScreenJoystick")
	# Clean-up of the plugin goes here.
	pass
