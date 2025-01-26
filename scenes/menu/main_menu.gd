extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/startButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if $VBoxContainer/startButton.has_focus():
			_on_start_button_pressed()
		elif $VBoxContainer/creditButton.has_focus():
			_on_credit_button_pressed()
		elif $VBoxContainer/exitButton.has_focus():
			_on_exitbutton_pressed()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby/lobby.tscn")

func _on_credit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credit/credit.tscn")

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
