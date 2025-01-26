extends Control

@export var in_time: float = 0.5
@export var face_in_time: float = 1.5
@export var pause_time: float = 1.5
@export var fade_out_time: float = 1.5
@export var out_time: float = 0.5
@export var splash_screen: TextureRect
@export var change_scene_to_packed : PackedScene



func fade() -> void:
	splash_screen.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(splash_screen, "modulate:a", 1.0, fade_out_time)
	tween.tween_interval(pause_time)
	tween.tween_property(splash_screen, "modulate:a", 0.0, fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished
	get_tree().change_scene_to_packed(change_scene_to_packed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade()
	$"son bulles splash".play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
