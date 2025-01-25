extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_player_libelle(text_display : String)-> void :
	$MarginContainer/VBoxContainer/HBoxContainer/Label.text = str(text_display)


func set_player_icone(path_texture:String)->void:
	var spriteframe = load(path_texture)
	$MarginContainer/VBoxContainer/HBoxContainer/TextureRect.texture = spriteframe
