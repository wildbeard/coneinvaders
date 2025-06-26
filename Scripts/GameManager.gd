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
	updateLives(0)

func updateScore(val: int) -> void:
	score += val
	update_score.emit(score)

func updateLives(val: int) -> void:
	lives += val
	update_lives.emit(lives)
