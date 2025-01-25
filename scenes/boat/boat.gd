extends CharacterBody2D
class_name Player

const BASE_SPEED = 500.0
const BASE_ACCELERATION = 200.0
const INVU_TIME = 0.5
const KNOCKBACK_POWER = 500
const MAX_HEALTH = 4

var current_speed: float = BASE_SPEED
var friction : float = BASE_ACCELERATION / BASE_SPEED
var input : Vector2
var boat_orientation : String

# player life management 
var current_health : int
var is_alive : bool

# shoot management 
@onready var fire_timer = $FireTimer
@export var fire_rate : float = 0.7
var can_fire : bool = true

var bubble_bullet_scene = preload("res://scenes/bubble/bubble_bullet.tscn")

var player:int = -1
var inputDevice

# gestion frame d'invu 
var invu_timer = Timer.new()
var is_invu = false
var speed_boost_timer: Timer


func _ready():
	fire_timer.connect("timeout", set_can_fire)
	fire_timer.wait_time = fire_rate

	speed_boost_timer = Timer.new()
	speed_boost_timer.one_shot = true
	speed_boost_timer.timeout.connect(_on_speed_boost_timer_timeout)
	add_child(speed_boost_timer)
	
func init(lInputDevice, lPlayer, lAnimatedTexture: String):
	var spriteframe = load(lAnimatedTexture)
	inputDevice = DeviceInput.new(lInputDevice)
	player = lPlayer
	#print(name)
	print("=================")
	prints("player id ", player)
	prints("player name", name)
	print("=================")
	
	# INVU Frame
	add_child(invu_timer)
	invu_timer.timeout.connect(_on_invu_timer_timeout)
	invu_timer.set_one_shot(true)
	
	# health management
	is_alive = true
	current_health = MAX_HEALTH
	
	$sprite_animation.sprite_frames = spriteframe
	
	
	

func get_input():
	input.x = inputDevice.get_action_strength("player_right") - inputDevice.get_action_strength("player_left")
	input.y = inputDevice.get_action_strength("player_down") - inputDevice.get_action_strength("player_up")
	return input.normalized()

func _process(delta: float) -> void:
	manage_alive_state()
	if is_alive:
		apply_traction(delta)
		apply_friction(delta)
		set_direction_animation()
		manage_shooting_bubble()
		move_and_slide()


func apply_traction(delta: float)-> void:
	var traction = get_input()
	velocity += traction * current_speed * delta
	
func apply_friction(delta: float)-> void:
	velocity -= velocity * friction * delta
	
func set_direction_animation()->void:
	var direction = get_input()
	
	var angle = rad_to_deg(direction.angle())
	#print(angle)
	
	if angle >= -22.5 and angle < 22.5 :
		# right
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("right")
			boat_orientation = "right"
		
	elif  angle >= 22.5 and angle < 67.5 :
		# right down
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("right_down")
			boat_orientation = "right_down"
		
	elif  angle >= 67.5 and angle < 112.5 :
		# down
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("down")
			boat_orientation = "down"
		
	elif  angle >= 135 and angle < 157.5 :
		#right down
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = true
			$sprite_animation.flip_v = false
			$sprite_animation.play("right_down") # left_down
			boat_orientation = "left_down"
		
	elif  angle <= -22.5 and angle > -67.5 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = true
			$sprite_animation.flip_v = false
			$sprite_animation.play("left_up") #right up
			boat_orientation = "right_up"
		
	elif  angle <=-67.5 and angle > -135 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("up") #up
			boat_orientation = "up"
		
	elif  angle <= -135 and angle > -157.5 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = false
			$sprite_animation.flip_v = false
			$sprite_animation.play("left_up") #left up
			boat_orientation = "left_up"
		
	elif  angle <= -157.5 or angle > 157.5 :
		if (direction.y != 0.0 || direction.x != 0.0):
			$sprite_animation.flip_h = true
			$sprite_animation.flip_v = false
			$sprite_animation.play("right") #left
			boat_orientation = "left"
		
func manage_shooting_bubble()-> void:
	var state_left_trigger = inputDevice.get_action_strength("player_fire_left")
	var state_right_trigger = inputDevice.get_action_strength("player_fire_right")
	
	if can_fire and (state_left_trigger > 0 or state_right_trigger > 0)  : 
		if state_left_trigger >= state_right_trigger :
			
			can_fire = false
			fire_timer.start()
			var bubble_bullet = bubble_bullet_scene.instantiate()
			bubble_bullet.setup_bubble(player)
			bubble_bullet.position = global_position
			bubble_bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(get_angle_fire_bullet_left()))
			get_parent().add_child(bubble_bullet)
		else :
			
			# calcule du vecteur de la bullet
			can_fire = false
			fire_timer.start()
			var bubble_bullet = bubble_bullet_scene.instantiate()
			bubble_bullet.setup_bubble(player)
			bubble_bullet.position = global_position
			bubble_bullet.direction = Vector2.RIGHT.rotated(deg_to_rad(get_angle_fire_bullet_right()))
			get_parent().add_child(bubble_bullet)
		

func get_angle_fire_bullet_left()->float:
	
	var shoot_radius : float = 0.0
	if boat_orientation == "up":
		shoot_radius = 180.0
	elif boat_orientation == "right_up" :
		shoot_radius = -135.0
	elif boat_orientation == "right" :
		shoot_radius = -90.0
	elif boat_orientation == "right_down" :
		shoot_radius = -45.0
	elif boat_orientation == "down" :
		shoot_radius = 0.0
	elif boat_orientation == "left_down" :
		shoot_radius = 45.0
	elif boat_orientation == "left" :
		shoot_radius = 90.0
	elif boat_orientation == "left_up" :
		shoot_radius = 135.0
	return shoot_radius
	
func get_angle_fire_bullet_right()->float:
	var shoot_radius : float = 0.0
	
	if boat_orientation == "up":
		shoot_radius = 0.0
	elif boat_orientation == "right_up" :
		shoot_radius = 45.0
	elif boat_orientation == "right" :
		shoot_radius = 90.0
	elif boat_orientation == "right_down" :
		shoot_radius = 135.0
	elif boat_orientation == "down" :
		shoot_radius = 180.0
	elif boat_orientation == "left_down" :
		shoot_radius = -135.0
	elif boat_orientation == "left" :
		shoot_radius = -90.0
	elif boat_orientation == "left_up" :
		shoot_radius = -45.0
	return shoot_radius

func set_can_fire() -> void:
	can_fire = true
	fire_timer.stop()
	
func get_play_id()->int:
	return player

func manage_bubble_hit()->void:
	print('outch')
	if not is_invu:
		is_invu = true
		invu_timer.start(INVU_TIME)

		# manage knockback
		
		# manage damage
		current_health -= 1
		# send signal to update hud ??
		


func manage_alive_state ()-> void :
	if is_alive:
		if current_health <= 0 :
			is_alive = false
			$sprite_animation.visible=false

func get_player_health()->int:
	return current_health

func _on_invu_timer_timeout():
	is_invu = false

func get_power_up(type):    
	if(type == GameData.PowerType.BUBBLE):
		bubble_powerup()
	elif(type == GameData.PowerType.BOAT):
		boat_powerup()
	else:
		print("Invalid power up type")

func bubble_powerup():
	pass

func boat_powerup():
	var power_ups = ["speed_boost"]
	var random_index = randi() % power_ups.size()
	var selected_power_up = power_ups[random_index]

	match selected_power_up:
		"speed_boost":
			apply_speed_boost()
		"default":
			print("Invalid power up")


func apply_speed_boost():
	print("Speed boost applied")
	set_speed(5000)
	speed_boost_timer.start(5.0)

func _on_speed_boost_timer_timeout():
	print("Speed boost expired")
	set_speed(BASE_SPEED)

func set_speed(speed: float):
	current_speed = speed
	friction = BASE_ACCELERATION / current_speed
