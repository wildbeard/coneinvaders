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

var hasProjectileOut: bool = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var input: Vector2
	input.x = Input.get_axis("move_left", "move_right")

	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input.normalized() * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)

	move_and_slide()

	if !hasProjectileOut && Input.is_action_just_pressed("shoot"):
		hasProjectileOut = true
		_shoot()

func _shoot() -> void:
	var projectile: Projectile = PROJECTILE_SCENE.instantiate()
	var startingPos: Vector2
	projectile.source = Projectile.SpawnSource.PLAYER
	startingPos.x = global_position.x + sprite.texture.get_width() / 5.5
	startingPos.y = global_position.y - 10

	projectile.global_position = startingPos
	projectile.projectile_hit.connect(Callable(_on_projectile_hit).bind(projectile), CONNECT_ONE_SHOT)
	add_child(projectile)

func _on_area_2d_area_entered(area: Area2D) -> void:
	player_hit.emit()

func _on_projectile_hit(target: Projectile.TargetHit, projectile: Projectile) -> void:
	var texture: Texture

	if target == Projectile.TargetHit.ENEMY:
		texture = HIT_TEXTURE
		_enemy_hit()
	elif target == Projectile.TargetHit.BUNKER:
		texture = BUNKER_HIT
		_bunker_hit()

	if texture:
		_set_sprite_texture(texture)
		get_tree().create_timer(0.25).timeout.connect(Callable(_set_sprite_texture).bind(BASE_TEXTURE), CONNECT_ONE_SHOT)

	hasProjectileOut = false
	projectile.queue_free()

func _set_sprite_texture(texture: Texture) -> void:
	sprite.texture = texture

func _enemy_hit() -> void:
	pass

func _bunker_hit() -> void:
	pass
