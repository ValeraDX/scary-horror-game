extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	text = str(ProjectSettings.get_setting("input_devices/pointing/emulate_mouse_from_touch"), $"../MultiTouchPanel".value)
	
	pass

