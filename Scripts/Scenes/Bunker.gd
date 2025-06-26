extends Node2D
class_name Bunker

@onready var topLeft: Area2D = %TopLeft
@onready var topRight: Area2D = %TopRight
@onready var bottomRight: Area2D = %BottomRight
@onready var bottomLeft: Area2D = %BottomLeft

var sectionHp: Dictionary = {
	"topLeft": 5,
	"topRight": 5,
	"bottomRight": 5,
	"bottomLeft": 5,
}

func _ready() -> void:
	topLeft.area_entered.connect(Callable(_on_area_2d_area_entered).bind(topLeft))
	topRight.area_entered.connect(Callable(_on_area_2d_area_entered).bind(topRight))
	bottomLeft.area_entered.connect(Callable(_on_area_2d_area_entered).bind(bottomLeft))
	bottomRight.area_entered.connect(Callable(_on_area_2d_area_entered).bind(bottomRight))

func _on_area_2d_area_entered(area: Area2D, section: Area2D) -> void:
	var sprite: Sprite2D = section.get_node("sprite")
	var flipped: bool = false
	var hp: int
	var hpKey: String
	var texture: Texture
	var texturePath: String = "res://Assets/Sprites/bunker/"
	
	match section:
		topLeft:
			hp = sectionHp.topLeft
			hpKey = "topLeft"
			flipped = true
			texturePath += "top_right_dmg_"
		topRight:
			hp = sectionHp.topRight
			hpKey = "topRight"
			texturePath += "top_right_dmg_"
		bottomRight:
			hp = sectionHp.bottomRight
			hpKey = "bottomRight"
			texturePath += "bottom_right_dmg_"
		bottomLeft:
			hp = sectionHp.bottomLeft
			hpKey = "bottomLeft"
			texturePath += "bottom_right_dmg_"
			flipped = true

	if hp - 1 <= 0:
		section.queue_free()
	else:
		hp = hp - 1
		texturePath += str(hp - 1) + ".png"
		sectionHp[hpKey] = hp
		sprite.texture = load(texturePath)
