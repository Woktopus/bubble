extends Node2D

@export var min_spawn_interval: float = 5.0
@export var max_spawn_interval: float = 15.0

var soap_scene = preload("res://scenes/events/soap.tscn")

#var spawned_event = []
var evet_type = ["soap"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var timer = Timer.new()
	timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	timer.timeout.connect(_on_SpawnTimer_timeout)
	add_child(timer)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_SpawnTimer_timeout()->void:
	print("spawn event")
	spawn_event()

func spawn_event()->void:
	# selection de l'event aléatoir 
	var event = evet_type.pick_random()
	if event == "soap":
		print("soap event")
		var markerStart : Marker2D = get_random_eventMarker()
		var markerDest : Marker2D = get_random_eventMarker()
		while markerStart.global_position == markerDest.global_position :
			markerDest = get_random_eventMarker()
		var new_event : Soap = soap_scene.instantiate()
		var randf_acceleration = randf_range(20.,100.0)
		add_child(new_event)
		new_event.init_soap(markerStart, markerDest, randf_acceleration)
		new_event.start_soap()
		#spawned_event.append(new_event)
		
func get_random_eventMarker()->Marker2D:
	var rand = randi_range(1,9)
	if rand == 1 :
		return $"../EventsMarker/MarkEvent1"
	elif rand == 2 :
		return $"../EventsMarker/MarkEvent2"
	elif rand == 3 :
		return $"../EventsMarker/MarkEvent3"
	elif rand == 4 :
		return $"../EventsMarker/MarkEvent4"
	elif rand == 5 :
		return $"../EventsMarker/MarkEvent5"
	elif rand == 6 :
		return $"../EventsMarker/MarkEvent6"
	elif rand == 7 :
		return $"../EventsMarker/MarkEvent7"
	elif rand == 8 :
		return $"../EventsMarker/MarkEvent8"
	else:
		return $"../EventsMarker/MarkEvent9"
