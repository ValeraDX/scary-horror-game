extends CheckButton
@export var variable : StringName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_pressed = bool(Gameplatform.get(variable))

func _on_toggled(toggled_on: bool) -> void:
	Gameplatform.set(variable, toggled_on)
