extends Node

var player_data: Dictionary = {}

var stage_textures = []
var current_stage_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_data = GameData.player_data
	stage_textures.append(load("res://assets/plageMINIATURE.png"))
	stage_textures.append(load("res://assets/bayouMINIATURE.png"))
	$Control/MarginContainer/HBoxContainer/MarginContainer/TextureRect.texture = stage_textures[current_stage_index]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	somemone_press_left_right()
	someone_wants_to_start()

func someone_wants_to_start() -> void:
	for player in player_data:
		var device = get_player_device(player)
		if MultiplayerInput.is_action_just_pressed(device, "start"):
			print(player_data)
			print("start"+str(device))
			start_game()

func somemone_press_left_right() -> void:
	for player in player_data:
		var device = get_player_device(player)
		if MultiplayerInput.is_action_just_pressed(device, "left"):
			print("left")
			current_stage_index = (current_stage_index - 1 + stage_textures.size()) % stage_textures.size()
			$Control/MarginContainer/HBoxContainer/MarginContainer/TextureRect.texture = stage_textures[current_stage_index]
		if MultiplayerInput.is_action_just_pressed(device, "right"):
			print("right")
			current_stage_index = (current_stage_index + 1) % stage_textures.size()
			$Control/MarginContainer/HBoxContainer/MarginContainer/TextureRect.texture = stage_textures[current_stage_index]


func get_player_device(player: int) -> int:
	return get_player_data(player, "device")

func get_player_data(player: int, key: StringName):
	if player_data.has(player) and player_data[player].has(key):
		return player_data[player][key]
	return null

func start_game():
	if current_stage_index == 0:
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/stage2/stage2.tscn")
