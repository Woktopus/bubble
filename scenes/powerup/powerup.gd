extends Area2D

signal player_entered(type, duration)
enum PowerType{BOAT, BUBBLE}

@export var type: PowerType = PowerType.BOAT
@export var duration: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		PowerType.BOAT:
			$Sprite2D.texture = load("res://assets/powerup/speed.png")
		PowerType.BUBBLE:
			$Sprite2D.texture = load("res://assets/powerup/explode.png")

func on_powerup_body_entered(body):
	if body.name == "Boat":  # Ensure it's the player
		body.get_power_up(type)
		queue_free()
