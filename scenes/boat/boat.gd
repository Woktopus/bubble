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
	set_direction_animation()
	move_and_slide()


func apply_traction(delta: float)-> void:
	var traction = get_input()
	velocity += traction * BASE_ACCELERATION  * delta
	
func apply_friction(delta: float)-> void:
	velocity -= velocity * friction * delta
	
func set_direction_animation()->void:
	var direction = get_input()
	var angle = rad_to_deg(direction.angle())
	
	if angle >= -22.5 and angle < 22.5 :
		# right
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("right")
		
	elif  angle >= 22.5 and angle < 67.5 :
		# right down
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("right_down")
		
	elif  angle >= 67.5 and angle < 112.5 :
		# down
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("down")
		
	elif  angle >= 135 and angle < 157.5 :
		#right down
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = true
			$sprite_animation.flip_v = false
			$sprite_animation.play("right_down")
		
	elif  angle <= -22.5 and angle > -67.5 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = true
			$sprite_animation.flip_v = false
			$sprite_animation.play("left_up") #right up
		
	elif  angle <=-67.5 and angle > -135 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("up") #up
		
	elif  angle <= -135 and angle > -157.5 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("left_up") #left up
		
	elif  angle <= -157.5 or angle > 157.5 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = true
			$sprite_animation.flip_v = false
			$sprite_animation.play("right") #left
		
	
