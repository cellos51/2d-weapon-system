class_name Player
extends CharacterBody3D


const CAMERA_SENSITIVITY: float = 0.001
const CAMERA_INTERPOLATE_SPEED: float = 30.0
const CAMERA_MAX_ANGLE: float = PI / 2.01
const CAMERA_MIN_ANGLE: float = -PI / 2.01
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

var weapon: Weapon = null # This is the weapon owned by the player.

@onready var player_camera: Camera3D = $Camera3D
@onready var player_camera_offset: Vector3 = global_position - player_camera.global_position


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player_camera.rotate_y(-event.screen_relative.x * CAMERA_SENSITIVITY)
		player_camera.rotation.x = clamp(
				player_camera.rotation.x - event.screen_relative.y * CAMERA_SENSITIVITY,
				CAMERA_MIN_ANGLE,
				CAMERA_MAX_ANGLE)


func _process(delta: float) -> void:
	player_camera.position = lerp(
			player_camera.position,
			global_position + player_camera_offset,
			CAMERA_INTERPOLATE_SPEED * delta)


func _physics_process(delta: float) -> void:
	# Apply the rotation from the camera to the player.
	rotation.y = player_camera.rotation.y

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle weapon.
	if is_instance_valid(weapon):
		# Set view bobbing.
		if is_on_floor():
			weapon.walking_speed = velocity.length()
		else:
			weapon.walking_speed = 0.0

		# Handle attack.
		if Input.is_action_just_pressed("game_attack"):
			weapon.attack()

	# Handle jump.
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement.
	var input_dir := Input.get_vector("game_left", "game_right", "game_forward", "game_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func equip_weapon(weapon_data: WeaponData) -> void:
	if not is_instance_valid(weapon_data):
		return
	elif is_instance_valid(weapon):
		weapon.queue_free()

	weapon = weapon_data.scene.instantiate()
	player_camera.add_child(weapon)
