extends Node2D

@onready var button: Button = $Control/Button

func _ready() -> void:
	button.button_up.connect(GlobalGameManager.startGame)
