extends Node2D

var _round: int = 1
var _startingPos: Vector2

func _ready() -> void:
	GlobalGameManager.update_score.connect(_on_update_score)
	GlobalGameManager.update_lives.connect(_on_update_lives)
	_startingPos = %EnemySpawnMarker.global_position

	_default_state()
	$EnemyController.initialize()
	_start()

func _start() -> void:
	$EnemyController.start_movement(true)

func _default_state() -> void:
	%Score.text = "0"
	%Lives.text = "3"

func _on_update_score(score: int) -> void:
	%Score.text = str(score)

func _on_update_lives(lives: int) -> void:
	%Lives.text = str(lives)
