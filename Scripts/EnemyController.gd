extends Node
class_name EnemyController

@export var enemySpawnMarker: Marker2D
@export var interval: float = 2.25

const VerticalStep: int = 38
const HorizontalStep: int = 65
const MaxHorizontalSteps: int = 8

var _isMoving: bool = false
var _horizontalDir: int = 1
var _horizontalRound: int = 0
var _round: int = 0

func stop_movement() -> void:
	_isMoving = false

func start_movement(initial: bool) -> void:
	_isMoving = true
	_enemies_move_timer.call_deferred(initial)

func _enemies_move_timer(initial: bool) -> void:
	if !_isMoving:
		return

	var timeout: float = 0.5 if initial else interval - (_round * 0.25)
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
