extends Node2D

@export var powerup_scene: PackedScene
@export var min_spawn_interval: float = 5.0
@export var max_spawn_interval: float = 15.0
@export var spawn_area: Rect2

var spawned_powerups = []

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	timer.timeout.connect(_on_SpawnTimer_timeout)
	add_child(timer)
	timer.start()

func _on_SpawnTimer_timeout() -> void:
	print("spawn powerup")
	spawn_powerup()

func spawn_powerup() -> void:
	var position = get_random_position()
	var powerup = powerup_scene.instantiate()
	powerup.position = position
	add_child(powerup)
	spawned_powerups.append(powerup)

func get_random_position() -> Vector2:
	var x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	return Vector2(x, y)


func despawn_powerup():
	print("despawn powerup")
	queue_free()
