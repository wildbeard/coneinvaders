extends Node2D

const ENEMY_SCENE: PackedScene = preload("res://Scenes/Enemy.tscn")
const ROWS: int = 5
const COLUMNS: int = 10

var _enemies: Array[Enemy] = []
var _round: int = 1
var _interval: float = 2.25
var _horizontalRound: int = 0
var _horizontalDir: int = 1
var _startingPos: Vector2

func _ready() -> void:
	GlobalGameManager.update_score.connect(_on_update_score)
	GlobalGameManager.update_lives.connect(_on_update_lives)
	_startingPos = %EnemySpawnMarker.global_position

	_default_state()
	_initialize_enemies()
	_start()

func _start() -> void:
	_enemies_move_timer(true)

func _enemies_move_timer(initial: bool) -> void:
	var timeout: float = _interval - (_round * -0.25) if !initial else 0.5
	get_tree()\
		.create_timer(timeout)\
		.timeout\
		.connect(Callable(_progress_enemies).bind(initial), CONNECT_ONE_SHOT)

func _progress_enemies(initial: bool) -> void:
	var pos: Vector2 = %EnemySpawnMarker.global_position
	var xToMove: int = 65

	if !initial && _horizontalRound == -1:
		_horizontalDir = 1
		xToMove = 0
		pos.y += 48
	elif _horizontalRound + 1 == 8:
		_horizontalDir = -1
		xToMove = 0
		pos.y += 48

	pos.x = pos.x + (xToMove * _horizontalDir)
	%EnemySpawnMarker.global_position = pos
	_horizontalRound = _horizontalRound + _horizontalDir
	print(_horizontalRound)
	_enemies_move_timer(false)

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
