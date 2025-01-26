extends Area2D

signal player_entered(type, duration)

@export var type: GameData.PowerType = GameData.PowerType.SPEED
@export var duration: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enum_values = GameData.PowerType.values()
	var random_index = randi() % enum_values.size()
	type = enum_values[random_index]

	match type:
		GameData.PowerType.HEALTH:
			$Sprite2D.texture = load("res://assets/powerup/jetonboat_heal.png")
		GameData.PowerType.SPEED:
			$Sprite2D.texture = load("res://assets/powerup/jetonbulle rapides.png")

func on_powerup_body_entered(body):
	if "boat" in body.get_groups():
		body.get_power_up(type)
		queue_free()
