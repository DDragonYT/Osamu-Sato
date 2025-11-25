extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.05
const LOOK_ANGLE = 45
@onready var camera = $Camera3D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Move the character
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		animation.queue("Step")
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		animation.stop()
		
	# Move the camera
	var camera_dir := Input.get_vector("look_up","look_down","look_left","look_right")
	var camera_direction := (transform.basis * Vector3(camera_dir.x, 0, camera_dir.y)).normalized()
	if camera_direction:
		camera.rotate_x(camera_dir.x/-20)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-LOOK_ANGLE), deg_to_rad(LOOK_ANGLE))
		rotate_y(camera_dir.y/-20)

	move_and_slide()

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rotate_y(-event.relative.x * LOOK_SENSITIVITY)
		#camera.rotate_x(-event.relative.y * LOOK_SENSITIVITY)
		#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-79), deg_to_rad(79))
