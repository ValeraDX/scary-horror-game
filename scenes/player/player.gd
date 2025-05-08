extends CharacterBody3D
signal kill(cause)
const SPEED = 7.0
const JUMP_VELOCITY = 8
const mouseSensitivity = 200
var posh = 0
var gamepadinput : Vector2
@onready var enemy = get_parent().get_node("scarymonter")
func _ready() -> void:
	if Gameplatform.mobile == false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$CanvasLayer/Control/TouchScreenJoystick.queue_free()
		$CanvasLayer/Control/TouchScreenButton.queue_free()

func _physics_process(delta: float) -> void:
	gamepadinput = Input.get_vector("cam_left", "cam_right", "cam_down", "cam_up")
	rotation.y -= gamepadinput.x * delta * 3.5
	$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x += gamepadinput.y * delta * 3.5
	$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x = clamp($Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
	if position.y < -5:
		posh = 0
		get_tree().reload_current_scene()
	$SubViewportContainer/SubViewport/backcam.position = Vector3(position.x + 3, position.y + 2, position.z + 3)
	$SubViewportContainer/SubViewport/backcam.look_at(position)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and posh < 6:
		$AnimationPlayer.play("walk", -1, 1.3)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if posh < 6:
			$AnimationPlayer.play("idle")
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if posh >=6:
		$AnimationPlayer.play("backflip")
		$SubViewportContainer.visible = true
	if posh >= 6 and $Skeleton/SonicRushE3BetaTitle.playing == false:
		$Skeleton/SonicRushE3BetaTitle.play()
		if Gameplatform.mobile == true:
			$CanvasLayer/Control/TouchScreenJoystick.queue_free()
			$CanvasLayer/Control/TouchScreenButton/TouchScreenButton.queue_free()
	move_and_slide()
	

func _input(event):
	#if event is InputEventJoypadMotion:
		#if event.axis == JoyAxis.JOY_AXIS_RIGHT_X:
			#rotation.y -= event.axis_value
		#if event.axis == JoyAxis.JOY_AXIS_RIGHT_Y:
			#$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x -= event.axis_value
		#$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x = clamp($Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
	if event is InputEventMouseMotion and Gameplatform.mobile == false:
		rotation.y -= event.relative.x / mouseSensitivity
		$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x -= event.relative.y / mouseSensitivity
		$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x = clamp($Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
	if event is InputEventScreenDrag and Gameplatform.mobile == true:
		rotate_y(deg_to_rad(-event.relative.x / mouseSensitivity * 32))
		$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x -= event.relative.y / mouseSensitivity
		$Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x = clamp($Skeleton/BoneAttachment3D/Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90) )

func generickill() -> void:
	$Aaaaaaaaaaaaaa.play()
	$CanvasLayer/AnimationPlayer.play("dead")
	print("damn")


func _on_scarymonter_kill(cause: Variant) -> void:
	if posh < 6:
		generickill()
	


func _on_poshalko_collected() -> void:
	posh+=1
	$CanvasLayer/Control/TextureProgressBar.value+=1
	$"Skeleton/CreepyBellSoundEffect-KiiroKarol".play()





func _on_touch_screen_button_pressed() -> void:
	Input.action_press("jump")
	Input.action_release("jump")
