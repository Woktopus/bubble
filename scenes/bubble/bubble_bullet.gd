#extends CharacterBody2D
extends Area2D
class_name BubbleBulet

var direcion : Vector2

@export var bullet_speed : float = 250.0
@onready var visible_notifier = $VisibleNotifier as VisibleOnScreenNotifier2D

var direction = Vector2.RIGHT

func _ready():
	pass

func _physics_process(delta: float) -> void:
	move_bubble(delta)
	
func _setup_bubble() -> void:
	pass

func move_bubble(delta : float) -> void:
	#move_and_collide(direcion * bullet_speed * delta)
	var velocity = direction * bullet_speed * delta
	global_position += velocity

#func _process(delta: float) -> void:
	#position += direcion * bullet_speed * delta



func bubble_explode() -> void:
	pass
