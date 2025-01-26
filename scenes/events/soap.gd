extends Area2D
class_name Soap

var soap_speed : float = 200.0
var acceleration_speed : float
var marker_source : Marker2D
var marker_destination : Marker2D

var destination_position : Vector2

var is_moving : bool = false


func init_soap(source : Marker2D, destination : Marker2D, acceleration: float) -> void:
	marker_source = source
	marker_destination = destination
	acceleration_speed = acceleration
	prints("soap setup de  "+str(source.global_position)+" vers "+str(destination.global_position)+"")
	
func start_soap():
	position = marker_source.global_position
	destination_position = marker_destination.global_position
	is_moving = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	go_there(delta)


func go_there(delta:float)-> void:
	if is_moving :
		position = position.move_toward(destination_position, delta * soap_speed)
		
	if position == destination_position : 
		is_moving = false
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "boat" in body.get_groups():
		print("boat hit soap")
		body.manage_bubble_hit()
