extends Node
var touch = false
var vr = false
var enablemouse = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		touch = true
	else:
		touch = false
