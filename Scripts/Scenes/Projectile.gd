extends Area2D
class_name Projectile

enum TargetHitType {
	ENEMY = 2,
	BUNKER = 8,	
	OUT_OF_BOUNDS = 16,
}

enum SpawnSource {
	PLAYER,
	ENEMY,
}

signal projectile_hit(target: int, area: Area2D)

@export var speed: float = 350.0

@onready var sprite: Sprite2D = $Sprite2D

var _spawn_source: int = SpawnSource.PLAYER

func _ready() -> void:
	top_level = true

func setCollisionMask(layer: int, val: bool) -> void:
	set_collision_mask_value(layer, val)

func setSpawnSource(spawnSource: SpawnSource) -> void:
	_spawn_source = spawnSource

func getSpawnSource() -> SpawnSource:
	return _spawn_source

func _process(delta: float) -> void:
	if _spawn_source == SpawnSource.PLAYER:
		global_position.y -= speed * delta
	else:
		global_position.y += speed * delta

func _on_area_2d_entered(area: Area2D) -> void:
	if area is Projectile:
		return

	var target: TargetHitType

	if area.collision_layer == 2:
		target = TargetHitType.ENEMY
	# Bunker
	elif area.collision_layer == 8:
		target = TargetHitType.BUNKER
	# Out of Bounds Collision
	elif area.collision_layer == 16:
		target = TargetHitType.OUT_OF_BOUNDS

	projectile_hit.emit(target, area)
