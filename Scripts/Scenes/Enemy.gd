extends Node2D
class_name Enemy

@export var fire_rate: float = 2.5
@export var enemy_type: int = 0
@export var score_given: int = 100

@onready var sprite: Sprite2D = $Sprite2D

# @TODO: Make this an exported var
const PROJECTILE_SCENE: PackedScene = preload("res://Scenes/Projectile.tscn")

var lastFired: float = 0.0

func _ready() -> void:
	pass

func shoot() -> void:
	var projectile: Projectile = PROJECTILE_SCENE.instantiate()
	projectile.setSpawnSource(Projectile.SpawnSource.ENEMY)
	projectile.setCollisionMask(2, false)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Projectile \
		&& area.has_method('getSpawnSource') \
		&& area.getSpawnSource() == Projectile.SpawnSource.PLAYER:
		queue_free()
