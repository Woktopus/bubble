extends CharacterBody2D
class_name Player

const BASE_SPEED = 500.0
const BASE_ACCELERATION = 200.0

var friction : float = BASE_ACCELERATION / BASE_SPEED
var input : Vector2

func get_input():
	input.x = Input.get_action_strength("player1_right") - Input.get_action_strength("player1_left")
	input.y = Input.get_action_strength("player1_down") - Input.get_action_strength("player1_up")
	return input.normalized()



func _process(delta: float) -> void:
	apply_traction(delta)
	apply_friction(delta)
	move_and_slide()

	
func apply_traction(delta: float)-> void:
	var traction = get_input()
	velocity += traction * BASE_ACCELERATION  * delta
	
func apply_friction(delta: float)-> void:
	velocity -= velocity * friction * delta
	
	
	
