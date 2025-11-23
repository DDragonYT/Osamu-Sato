extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var LOOK_SENSITIVITY = 5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var camera_dir := Input.get_vector("look_up","look_down","look_left","look_right")
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var camera_direction := (transform.basis * Vector3(camera_dir.x, 0, camera_dir.y)).normalized()
	var camera = $Camera3D
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$AnimationPlayer.queue("Step")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$AnimationPlayer.stop()
	
	if camera_direction:
		camera.rotate_x(camera_dir.x/-20)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-79), deg_to_rad(79))
		rotate_y(camera_dir.y/-20)

	move_and_slide()
