extends Timer
@export var floor : Node
func _on_timeout() -> void:
	floor.visible = true
