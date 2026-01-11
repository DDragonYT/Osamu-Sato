extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.05
const LOOK_ANGLE = 45
var game_controller: Node
@onready var camera = $Camera3D
@onready var animation = $AnimationPlayer
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var interact: CanvasLayer = $InteractPrompt


func _ready() -> void:
	pass
	#raycast.target_position = Vector3.FORWARD * 8.0	
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func send_raycast():
	if raycast.is_colliding():
		var _collision_point: Vector3 = raycast.get_collision_point()
		var _collision_normal: Vector3 = raycast.get_collision_normal()
		var collider: Node3D = raycast.get_collider()
		if collider.is_in_group("Door"):
			interact.show()
			return(collider)
	else:
		interact.hide()

func _physics_process(delta: float) -> void:	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("Jump")
	
	if Input.is_action_just_pressed("interact"):
		var collider = send_raycast()
		if collider:
			game_controller.start_switch(collider)
				
	# Move the character
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor():
			animation.queue("Step")
		else:
			animation.stop()
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
	send_raycast()
