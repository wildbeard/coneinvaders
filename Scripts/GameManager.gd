extends Node
class_name GameManager

signal game_over()
signal update_score(score: int)
signal update_lives(lives: int)

const GAME_SCENE: PackedScene = preload("res://Scenes/Game.tscn")

var score: int = 0
var lives: int = 3

func startGame() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)
	score = 0
	lives = 3
	updateScore(0)
	updateLives(lives)

func updateScore(val: int) -> void:
	score += val
	update_score.emit(score)

func updateLives(val: int) -> void:
	lives = val

	if lives <= 0:
		_game_over()
	else:
		update_lives.emit(lives)

func _game_over() -> void:
	startGame()
