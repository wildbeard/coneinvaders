extends CharacterBody2D
class_name Player

signal player_hit()

@onready var sprite: Sprite2D = $Sprite2D
@onready var area2d: Area2D = $Area2D

const ACCELERATION: float = 5500.0
const SPEED: float = 150.0
const PROJECTILE_SCENE: PackedScene = preload("res://Scenes/Projectile.tscn")
const BASE_TEXTURE = preload("res://Assets/Sprites/cudaW.png")
const HIT_TEXTURE = preload("res://Assets/Sprites/cudaGasm.png")
const BUNKER_HIT = preload("res://Assets/Sprites/cudaWTF.png")
const MISS_TEXTURE = preload("res://Assets/Sprites/cudaPotato.png")

var hasProjectileOut: bool = false
var canMove: bool = true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var input: Vector2
	input.x = Input.get_axis("move_left", "move_right")

	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input.normalized() * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)

	if canMove:
		move_and_slide()

	if !hasProjectileOut && Input.is_action_just_pressed("shoot"):
		hasProjectileOut = true
		_shoot()

func disableMovement() -> void:
	canMove = false

func enableMovement() -> void:
	canMove = true

func _shoot() -> void:
	var projectile: Projectile = PROJECTILE_SCENE.instantiate()
	var startingPos: Vector2
	projectile.setSpawnSource(Projectile.SpawnSource.PLAYER)
	startingPos.x = global_position.x + sprite.texture.get_width() / 5.5
	startingPos.y = global_position.y - 10

	projectile.global_position = startingPos
	projectile.projectile_hit.connect(Callable(_on_projectile_hit).bind(projectile), CONNECT_ONE_SHOT)
	add_child(projectile)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Projectile:
		area.queue_free()

	player_hit.emit()

func _on_projectile_hit(hitType: Projectile.TargetHitType, targetHit: Area2D, projectile: Projectile) -> void:
	var texture: Texture

	if hitType == Projectile.TargetHitType.ENEMY:
		texture = HIT_TEXTURE
		_enemy_hit(targetHit)
	elif hitType == Projectile.TargetHitType.BUNKER:
		texture = BUNKER_HIT
		_bunker_hit()
	elif hitType == Projectile.TargetHitType.OUT_OF_BOUNDS:
		texture = MISS_TEXTURE
		hasProjectileOut = false

	if texture:
		_set_sprite_texture(texture)
		get_tree().create_timer(0.25).timeout.connect(Callable(_set_sprite_texture).bind(BASE_TEXTURE), CONNECT_ONE_SHOT)

	hasProjectileOut = false
	projectile.queue_free()

func _set_sprite_texture(texture: Texture) -> void:
	sprite.texture = texture

# @TODO: Implement scores for other enemy types
func _enemy_hit(area: Area2D) -> void:
	# get_parent here is kind of a no-no
	if area.get_parent() is Enemy:
		GlobalGameManager.updateScore(area.get_parent().score_given)

func _bunker_hit() -> void:
	GlobalGameManager.updateScore(-50)
