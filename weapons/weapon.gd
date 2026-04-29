class_name Weapon
extends Node3D


var player: Player = null
var weapon_view: Node3D = null
var attack_audio: AudioStreamPlayer = null
var attack_timer: Timer = null

var damage: float = 0.0
var attack_speed: float = 0.0
var attack_range: float = 0.0


func _init(player_reference: Player, weapon_data: WeaponData) -> void:
	player = player_reference

	weapon_view = weapon_data.view_scene.instantiate()
	weapon_view.weapon = self
	add_child(weapon_view)

	attack_audio = AudioStreamPlayer.new()
	attack_audio.stream = weapon_data.attack_audio
	add_child(attack_audio)

	attack_timer = Timer.new()
	attack_timer.one_shot = true
	add_child(attack_timer)

	damage = weapon_data.damage
	attack_speed = weapon_data.attack_speed
	attack_range = weapon_data.attack_range


func attack() -> void:
	if attack_timer.time_left > 0.0:
		return
	else:
		attack_timer.start(1.0 / attack_speed)

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
			global_position,
			global_position + -global_transform.basis.z * attack_range)
	query.exclude.append(player.get_rid())
	var result = space_state.intersect_ray(query)

	if not result.is_empty() and result.collider is Enemy:
		var enemy = result.collider
		enemy.take_damage(damage)


	attack_audio.play()
	weapon_view.recoil()
