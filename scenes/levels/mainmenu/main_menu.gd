extends Node3D
@export var music : AudioStreamPlayer
@export var musicsync : AnimationPlayer
@export var jumpto : float = 7.5
func _input(event: InputEvent) -> void:
	if musicsync.current_animation_position < jumpto:
		if event.get_class() in [&"InputEventScreenTouch", &"InputEventJoypadButton", &"InputEventKey"]:
			musicsync.seek(jumpto)
			music.seek(jumpto)
