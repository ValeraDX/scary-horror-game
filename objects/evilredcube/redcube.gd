extends Area3D
signal kill(cause)


func _on_body_entered(body: Node3D) -> void:
	if body.get_collision_layer() == 1:
		body.generickill()
