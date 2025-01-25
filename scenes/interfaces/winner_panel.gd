extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup_text(text_to_display : String)-> void:
	$MarginContainer/VBoxContainer/Panel/infoLabel.text = str(text_to_display)
	
