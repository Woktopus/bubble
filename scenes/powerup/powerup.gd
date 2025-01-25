extends Area2D

signal player_entered(type, duration)

@export var type: GameData.PowerType = GameData.PowerType.BOAT
@export var duration: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		GameData.PowerType.BOAT:
			$Sprite2D.texture = load("res://assets/powerup/speed.png")
		GameData.PowerType.BUBBLE:
			$Sprite2D.texture = load("res://assets/powerup/explode.png")

func on_powerup_body_entered(body):
	if "boat" in body.get_groups():
		body.get_power_up(type)
		queue_free()
