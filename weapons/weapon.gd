class_name Weapon
extends Node3D


const VIEW_SWAY_SPEED: Vector3 = Vector3(20.0, 30.0, 70.0)
const VIEW_SWAY_MAX_DISTANCE: Vector3 = Vector3(0.3, 0.2, 0.2)

const VIEW_BOB_SPEED: Vector2 = Vector2(2.0, 4.0)
const VIEW_BOB_INTENSITY: Vector2 = Vector2(0.05, 0.03)
const VIEW_BOB_TRANSITION_SPEED: float = 5.0

const VIEW_RECOIL_ANGLE: float = 3.34 # This is in radians.
const VIEW_RECOIL_INTENSITY: float = 0.3
const VIEW_RECOIL_SPEED: float = 20.0

var view_recoil_position := Vector3()

var view_sway_position := Vector3()

var view_bob_position := Vector3()
var view_bob_transition: float = 0.0
var elapsed_time_walking: float = 0.0
var walking_speed: float = 0.0

var gun_view_last_position := Vector3()

@onready var gun_view: Node3D = $View
@onready var gun_view_initial_position: Vector3 = gun_view.transform.origin


func _process(delta: float) -> void:
	view_recoil_position = lerp(view_recoil_position, Vector3.ZERO, VIEW_RECOIL_SPEED * delta)
	_view_sway(delta)
	_view_bob(delta)
	gun_view.position = (
			gun_view_initial_position +
			view_sway_position +
			view_bob_position +
			view_recoil_position)
	gun_view_last_position = gun_view.global_position


func _view_sway(delta: float) -> void:
	view_sway_position -= global_transform.basis.inverse() * (gun_view.global_position - gun_view_last_position)
	view_sway_position = view_sway_position.clamp(-VIEW_SWAY_MAX_DISTANCE, VIEW_SWAY_MAX_DISTANCE)
	
	view_sway_position.x = lerp(view_sway_position.x, 0.0, VIEW_SWAY_SPEED.x * delta)
	view_sway_position.y = lerp(view_sway_position.y, 0.0, VIEW_SWAY_SPEED.y * delta)
	view_sway_position.z = lerp(view_sway_position.z, 0.0, VIEW_SWAY_SPEED.z * delta)


func _view_bob(delta: float) -> void:
	if walking_speed > 0.0:
		view_bob_transition = lerp(view_bob_transition, 1.0, VIEW_BOB_TRANSITION_SPEED * delta)
	else:
		view_bob_transition = lerp(view_bob_transition, 0.0, VIEW_BOB_TRANSITION_SPEED * delta)

	elapsed_time_walking += walking_speed * delta
	view_bob_position = Vector3(
			sin(elapsed_time_walking * VIEW_BOB_SPEED.x) * VIEW_BOB_INTENSITY.x,
			sin(elapsed_time_walking * VIEW_BOB_SPEED.y) * VIEW_BOB_INTENSITY.y, 0.0) * view_bob_transition


func attack() -> void:
	var recoil_vector := Vector2.RIGHT.rotated(VIEW_RECOIL_ANGLE) * VIEW_RECOIL_INTENSITY
	view_recoil_position.x -= recoil_vector.x
	view_recoil_position.y += recoil_vector.y
