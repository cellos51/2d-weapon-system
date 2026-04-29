class_name Enemy
extends CharacterBody3D

const MAX_HEALTH = 100.0

var health: float = MAX_HEALTH


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func take_damage(damage: float) -> void:
	health -= damage
	position.y += 0.1

	if health <= 0.0:
		queue_free()
