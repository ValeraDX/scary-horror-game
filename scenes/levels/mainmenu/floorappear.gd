extends Timer
@export var node_floor : Node
func _on_timeout() -> void:
	node_floor.visible = true
