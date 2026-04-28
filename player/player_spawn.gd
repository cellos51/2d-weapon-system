class_name PlayerSpawn
extends Marker3D


const PlayerScene: PackedScene = preload("res://player/player.tscn")

@export var player_weapon: WeaponData = null


func _ready() -> void:
	var player := PlayerScene.instantiate()
	add_child(player)
	player.transform = transform
	player.equip_weapon(player_weapon)
