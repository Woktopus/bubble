extends Area2D

signal player_entered(type, duration)
enum PowerType{SPEED, OTHER}

@export var type: PowerType = PowerType.SPEED
@export var duration: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		PowerType.SPEED:
			$Sprite2D.texture = load("res://assets/powerup/speed.png")
		PowerType.OTHER:
			$Sprite2D.texture = load("res://assets/powerup/explode.png")

func on_powerup_body_entered(body):
	if body.name == "Boat":  # Ensure it's the player
		emit_signal("player_entered", type, duration)
		queue_free()
