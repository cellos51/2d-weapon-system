class_name Weapon
extends Node3D


var player: Player = null
var weapon_view: Node3D = null
var attack_audio: AudioStreamPlayer = null


func _init(player_reference: Player, weapon_data: WeaponData) -> void:
	player = player_reference

	weapon_view = weapon_data.view_scene.instantiate()
	weapon_view.weapon = self
	add_child(weapon_view)

	attack_audio = AudioStreamPlayer.new()
	attack_audio.stream = weapon_data.attack_audio
	add_child(attack_audio)


func attack() -> void:
	attack_audio.play()
	weapon_view.recoil()