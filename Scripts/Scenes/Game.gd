extends Node2D

@onready var player: Player = $CharacterBody2D
@onready var enemyController: EnemyController = $EnemyController

var _round: int = 1
var _startingPos: Vector2
var _playerStartingPos: Vector2

func _ready() -> void:
	GlobalGameManager.update_score.connect(_on_update_score)
	GlobalGameManager.update_lives.connect(_on_update_lives)
	player.player_hit.connect(_on_player_hit)
	_startingPos = %EnemySpawnMarker.global_position
	_playerStartingPos = player.global_position

	_default_state()
	enemyController.initialize()
	_start()

func _start() -> void:
	enemyController.start_movement(true)

func _default_state() -> void:
	%Score.text = "0"
	%Lives.text = "3"

func _on_update_score(score: int) -> void:
	%Score.text = str(score)

func _on_update_lives(lives: int) -> void:
	%Lives.text = str(lives)

func _on_player_hit() -> void:
	player.disableMovement()
	enemyController.stop_movement()
	GlobalGameManager.updateLives(GlobalGameManager.lives - 1)
	await get_tree().create_timer(2).timeout
	player.global_position = _playerStartingPos
	player.enableMovement()
	enemyController.start_movement(false)
