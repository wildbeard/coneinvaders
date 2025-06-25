extends Node2D
class_name Projectile

signal out_of_bounds()
signal hit_enemy()

@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 150.0

func _ready() -> void:
	top_level = true

func _process(delta: float) -> void:
	global_position.y -= speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	# Out of Bounds Collision
	if area.collision_mask == 2:
		out_of_bounds.emit()
	else:
		hit_enemy.emit()
