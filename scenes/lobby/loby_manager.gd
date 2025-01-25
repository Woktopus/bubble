extends Node

# player is 0-3
# device is -1 for keyboard/mouse, 0+ for joypads
# these concepts seem similar but it is useful to separate them so for example, device 6 could control player 1.

signal player_joined(player)
signal player_left(player)

func _ready() -> void:
	$AudioStreamPlayer.play()


# map from player integer to dictionary of data
# the existence of a key in this dictionary means this player is joined.
# use get_player_data() and set_player_data() to use this dictionary.
var player_data: Dictionary = {}

const MAX_PLAYERS = 4
const MIN_PLAYERS = 1

func join(device: int):
	var player = next_player()
	if player >= 0:
		# initialize default player data here
		player_data[player] = {
			"device": device,
			"team":0,
			#"skin":"duck",
			"skin":"res://assets/canard/sprite_frame_canard.tres",
			"icone":"res://assets/canard/Sprite-0001-Sheet.png"
			# load("res://assets/canard/sprite_frame_canard.tres")
		}
		player_joined.emit(player)

func leave(player: int):
	if player_data.has(player):
		player_data.erase(player)
		player_left.emit(player)

func get_player_count():
	return player_data.size()

func get_player_indexes():
	return player_data.keys()

func get_player_device(player: int) -> int:
	return get_player_data(player, "device")

# get player data.
# null means it doesn't exist.
func get_player_data(player: int, key: StringName):
	if player_data.has(player) and player_data[player].has(key):
		return player_data[player][key]
	return null

# set player data to get later
func set_player_data(player: int, key: StringName, value: Variant):
	# if this player is not joined, don't do anything:
	if player_data.has(player):
		player_data[player][key] = value

func set_player_skin(player: int, skin: String):
	set_player_data(player, "skin", skin)
	$kwaksound.play()

func set_player_icone(player: int, icone: String):
	set_player_data(player, "icone", icone)


func handle_join_input():
	for device in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(device, "join"):
			print("join")
			join(device)


func someone_wants_to_start() -> void:
	for player in player_data:
		var device = get_player_device(player)
		if MultiplayerInput.is_action_just_pressed(device, "start"):
			print(player_data)
			print("start"+str(device))
			start_game()


func is_device_joined(device: int) -> bool:
	for player_id in player_data:
		var d = get_player_device(player_id)
		if device == d: return true
	return false

# returns a valid player integer for a new player.
# returns -1 if there is no room for a new player.
func next_player() -> int:
	for i in MAX_PLAYERS:
		if !player_data.has(i): return i
	return -1

# returns an array of all valid devices that are *not* associated with a joined player
func get_unjoined_devices():
	var devices = Input.get_connected_joypads()
	# also consider keyboard player
	devices.append(-1)
	
	# filter out devices that are joined:
	return devices.filter(func(device): return !is_device_joined(device))

func start_game():
	if get_player_count() >= MIN_PLAYERS:
		print("start game")
		GameData.player_data = player_data

		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	else:
		print("not enough players")
