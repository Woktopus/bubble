#extends CharacterBody2D
extends Area2D
class_name BubbleBulet

var direcion : Vector2

@export var bullet_speed : float = 250.0
@onready var visible_notifier = $VisibleNotifier as VisibleOnScreenNotifier2D

var direction = Vector2.RIGHT
var state_alive :bool
var player_owner : int = -1

func _ready():
	pass

func setup_bubble(player_id:int)->void :
	state_alive = true
	player_owner = player_id
	

func _physics_process(delta: float) -> void:
	move_bubble(delta)

func move_bubble(delta : float) -> void:
	#move_and_collide(direcion * bullet_speed * delta)
	var velocity = direction * bullet_speed * delta
	global_position += velocity

#func _process(delta: float) -> void:
	#position += direcion * bullet_speed * delta

func bubble_explode() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if "boat" in body.get_groups():
		
		print("========================")
		prints("owner id %s ", player_owner)
		prints("target id target %s", body.get_play_id())
		print("========================")
		if body.get_play_id() != player_owner:
			queue_free()
			body.manage_bubble_hit()
	else:
		print("untracked collision bubble")
		queue_free()
