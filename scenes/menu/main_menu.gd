extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby/lobby.tscn")

func _on_credit_button_pressed() -> void:
	pass # Replace with function body.

func _on_exitbutton_pressed() -> void:
	get_tree().quit()

func _on_start_button_mouse_entered() -> void:
	pass # Replace with function body.
	$VBoxContainer/exitbutton/AudioStreamPlayer.play()

func _on_credit_button_mouse_entered() -> void:
	pass # Replace with function body.
	$VBoxContainer/exitbutton/AudioStreamPlayer.play()

func _on_exitbutton_mouse_entered() -> void:
	pass # Replace with function body.
	$VBoxContainer/exitbutton/AudioStreamPlayer.play()
