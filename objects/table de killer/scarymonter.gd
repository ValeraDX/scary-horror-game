extends CharacterBody3D

signal kill(cause)
var SPEED = 250.0
const JUMP_VELOCITY = 4.5
@onready var player = get_parent().get_node("player")

func _physics_process(delta: float) -> void:
	SPEED = 100 + player.posh * 40
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#if player.posh >= 6:
		#queue_free()

	$AudioStreamPlayer3D.pitch_scale = clampf((50**2 - position.distance_squared_to(player.position)) / (40**2), 0.1, 5.0)
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	look_at(player.position)

	velocity = SPEED * global_transform.basis.z * delta * -1
	move_and_slide()



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_collision_layer() == 1:
		kill.emit("monter")
