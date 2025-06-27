extends Node
class_name EnemyController

@export var enemySpawnMarker: Marker2D
## The time between enemy movements
@export var movementInterval: float = 2.25
## The time between selecting a random enemy to shoot from.
@export var enemyFireInterval: float = 2.25
## The current round. This will be used for "difficulty" scaling.
@export var currentRound: int = 0

const ENEMY_SCENE: PackedScene = preload("res://Scenes/Enemy.tscn")
const ROWS: int = 5
const COLUMNS: int = 10
const VerticalStep: int = 38
const HorizontalStep: int = 65
const MaxHorizontalSteps: int = 8

var _isMoving: bool = false
var _horizontalDir: int = 1
var _horizontalRound: int = 0
var _enemies: Array[Enemy] = []

func initialize() -> void:
	var startingPos: Vector2 = enemySpawnMarker.global_position

	for r in ROWS:
		# @TODO: Enemy type based on row
		for c in COLUMNS:
			var e: Enemy = ENEMY_SCENE.instantiate()
			# @TODO: Dynamically get the width/height -- but sprite is an onready
			# so we can't access it until _after_ it added to the scene
			e.global_position.x = startingPos.x + (64 * c)
			e.global_position.y = startingPos.y + (48 * r)
			e.score_given = e.score_given * (ROWS - floor(r / 2))

			_enemies.push_back(e)
			# Add them to the marker so we can move the marker later
			%EnemySpawnMarker.add_child(e)

func stop_movement() -> void:
	_isMoving = false

func start_movement(initial: bool) -> void:
	_isMoving = true
	_enemies_move_timer.call_deferred(initial)
	_enemies_shoot_timer.call_deferred()

func _enemies_shoot_timer() -> void:
	# We can't type Array[Enemy] here due to some weird shit under the hood. idk
	var validEnemies: Array = _enemies.filter(func(e): return is_instance_valid(e))

	if !_isMoving || validEnemies.is_empty():
		return

	var timeout: float = enemyFireInterval - (currentRound * 0.25)
	var shoot: Callable = func():
		if !_isMoving:
			return

		var e: Enemy

		while !e:
			e = validEnemies.pick_random()

		e.shoot()
		_enemies_shoot_timer()

	# We _want_ this to be async so it does not impede the movement.
	# If we await the timer it blocks the movement until the timer is finished.
	get_tree().create_timer(timeout).timeout.connect(shoot, CONNECT_ONE_SHOT)

func _enemies_move_timer(initial: bool) -> void:
	if !_isMoving:
		return

	var timeout: float = 0.5 if initial else movementInterval - (currentRound * 0.25)
	await get_tree().create_timer(timeout).timeout

	if _isMoving:
		_progress_enemies(initial)

func _progress_enemies(initial: bool) -> void:
	var pos: Vector2 = enemySpawnMarker.global_position

	if !initial && _horizontalRound == -1 \
		|| _horizontalRound + 1 == MaxHorizontalSteps:
			_horizontalDir *= -1
			pos.y += VerticalStep
	else:
		pos.x += HorizontalStep * _horizontalDir

	enemySpawnMarker.global_position = pos
	_horizontalRound = wrapi(_horizontalRound + _horizontalDir, -1, MaxHorizontalSteps)

	if _isMoving:
		_enemies_move_timer.call_deferred(false)
