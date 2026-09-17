extends Node3D
signal collected

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_collision_layer() == 1:
		collected.emit()
		queue_free()
