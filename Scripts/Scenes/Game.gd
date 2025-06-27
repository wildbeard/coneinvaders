extends Node2D

const ENEMY_SCENE: PackedScene = preload("res://Scenes/Enemy.tscn")
const ROWS: int = 5
const COLUMNS: int = 10

var _enemies: Array[Enemy] = []
var _round: int = 1
var _startingPos: Vector2

func _ready() -> void:
	GlobalGameManager.update_score.connect(_on_update_score)
	GlobalGameManager.update_lives.connect(_on_update_lives)
	_startingPos = %EnemySpawnMarker.global_position

	_default_state()
	_initialize_enemies()
	_start()

func _start() -> void:
	$EnemyController.start_movement(true)

func _default_state() -> void:
	%Score.text = "0"
	%Lives.text = "3"

func _initialize_enemies() -> void:
	for r in ROWS:
		# @TODO: Enemy type based on row
		for c in COLUMNS:
			var e: Enemy = ENEMY_SCENE.instantiate()
			# @TODO: Dynamically get the width/height -- but sprite is an onready
			# so we can't access it until _after_ it added to the scene
			e.global_position.x = _startingPos.x + (64 * c)
			e.global_position.y = _startingPos.y + (48 * r)
			e.score_given = e.score_given * (ROWS - floor(r / 2))

			_enemies.push_back(e)
			# Add them to the marker so we can move the marker later
			%EnemySpawnMarker.add_child(e)

func _on_update_score(score: int) -> void:
	%Score.text = str(score)

func _on_update_lives(lives: int) -> void:
	%Lives.text = str(lives)
