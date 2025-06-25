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
	startingPos.x = global_position.x + sprite.texture.get_width() / 5.5
	startingPos.y = global_position.y - 10

	projectile.global_position = startingPos
	projectile.out_of_bounds.connect(Callable(_on_projectile_out_of_bounds).bind(projectile), CONNECT_ONE_SHOT)
	projectile.hit_enemy.connect(Callable(_on_projectile_hit).bind(projectile), CONNECT_ONE_SHOT)
	add_child(projectile)

func _on_area_2d_area_entered(area: Area2D) -> void:
	player_hit.emit()

func _on_projectile_hit(projectile: Projectile) -> void:
	hasProjectileOut = false
	projectile.queue_free()

func _on_projectile_out_of_bounds(projectile: Projectile) -> void:
	hasProjectileOut = false
	_set_sprite_texture(HIT_TEXTURE)
	get_tree().create_timer(0.25).timeout.connect(Callable(_set_sprite_texture).bind(BASE_TEXTURE), CONNECT_ONE_SHOT)
	projectile.queue_free()

func _set_sprite_texture(texture: Texture) -> void:
	sprite.texture = texture
