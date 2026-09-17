extends Control

func _ready() -> void:
	if Gameplatform.touch == false:
		queue_free()
