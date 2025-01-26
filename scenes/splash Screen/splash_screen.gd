extends Control

@export var in_time : float = 0.5
@export var face_in_time : float = 1.5
@export var pause_time : float = 1.5
@export var fade_out_time : float = 1.5
@export var out_time : float = 0.5
@export var splash_screen : TextureRect

func fade() -> void:
	splash_screen.modulate.a = 0.0
	var tween = self.create_tween
	tween.tween_interval(in_time)
	tween.tween_proprety(splash_screen, "modulate:a", 1.0,fade_out_time)
	tween.tween_interval(pause_time)
	tween.tween_proprety(splash_screen, "modulate:a", 0.0,fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
