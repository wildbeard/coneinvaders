extends Node2D
class_name Projectile

enum TargetHit {
	ENEMY = 0,
	OUT_OF_BOUNDS = 2,
	BUNKER = 8,
}

enum SpawnSource {
	PLAYER,
	ENEMY,
}

signal projectile_hit(target: int)

@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 150.0
var source: int

func _ready() -> void:
	top_level = true

func _process(delta: float) -> void:
	global_position.y -= speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.collision_mask)
	var target: TargetHit
	# Out of Bounds Collision
	if area.collision_mask == 2:
		target = TargetHit.OUT_OF_BOUNDS
	# Bunker
	elif area.collision_mask == 8:
		target = TargetHit.BUNKER
	else:
		target = TargetHit.ENEMY

	projectile_hit.emit(target)
