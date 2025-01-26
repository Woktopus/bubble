extends Node

# this is a singleton autoload in my project but for the purposes of this demo,
# this is simpler
@onready var loby_manager = $LobyManager

# map from player integer to the player node
var player_nodes = {}

var label_icons = {}
var secondary_label_icons = {}
var label_left_arrows = {}
var label_right_arrows = {}
var light = {}
func _ready():
	GameData.reset_all()
	loby_manager.player_joined.connect(spawn_player)
	loby_manager.player_left.connect(delete_player)
	label_icons = {	
		0: $Control/MarginContainer/GridContainer/VBoxP1/hboxp1pressA/LabelIconp1,
		1: $Control/MarginContainer/GridContainer/VBoxP2/hboxp2pressA/LabelIconp2,
		2: $Control/MarginContainer/GridContainer/VBoxP3/hboxp3pressA/LabelIconp3,
		3: $Control/MarginContainer/GridContainer/VBoxP4/hboxp4pressA/LabelIconp4
	}
	secondary_label_icons = {
		0: $Control/MarginContainer/GridContainer/VBoxP1/hboxp1pressA/Label3,
		1: $Control/MarginContainer/GridContainer/VBoxP2/hboxp2pressA/Label3,
		2: $Control/MarginContainer/GridContainer/VBoxP3/hboxp3pressA/Label3,
		3: $Control/MarginContainer/GridContainer/VBoxP4/hboxp4pressA/Label3
	}
	label_left_arrows = {
		0: $Control/MarginContainer/GridContainer/VBoxP1/HBoxContainer/LabelLeftArrow,
		1: $Control/MarginContainer/GridContainer/VBoxP2/HBoxContainer/LabelLeftArrow,
		2: $Control/MarginContainer/GridContainer/VBoxP3/HBoxContainer/LabelLeftArrow,
		3: $Control/MarginContainer/GridContainer/VBoxP4/HBoxContainer/LabelLeftArrow
	}
	label_right_arrows = {
		0: $Control/MarginContainer/GridContainer/VBoxP1/HBoxContainer/LabelRightArrow,
		1: $Control/MarginContainer/GridContainer/VBoxP2/HBoxContainer/LabelRightArrow,
		2: $Control/MarginContainer/GridContainer/VBoxP3/HBoxContainer/LabelRightArrow,
		3: $Control/MarginContainer/GridContainer/VBoxP4/HBoxContainer/LabelRightArrow
	}
	light = {
		0: $PointLightp1,
		1: $PointLightp2,
		2: $PointLightp3,
		3: $PointLightp4
	}

	#set visibility of right and left arrows to false
	for i in range(4):
		label_left_arrows[i].visible = false
		label_right_arrows[i].visible = false
		light[i].visible = false

func _process(_delta):
	loby_manager.handle_join_input()
	loby_manager.someone_wants_to_start()

func spawn_player(player: int):
	# Check if the player already exists and find the next available slot
	while player in player_nodes:
		player += 1

	# Find the next available LobbyPlayer node
	var player_node = null
	for i in range(4):
		var node = $Control/MarginContainer/GridContainer.get_child(i).get_child(0).get_child(1)
		if not node in player_nodes.values():
			player_node = node
			break

	if player_node == null:
		print("No available LobbyPlayer nodes.")
		return

	# Connect the player node to the player's input
	player_nodes[player] = player_node

	# let the player know which device controls it
	var device = loby_manager.get_player_device(player)
	player_node.init(player, device)

	player_node.leave.connect(on_player_leave)

	update_label_icon(player, "xbox_button_b_outline", Color.RED, "to leave")
	label_left_arrows[player].visible = true
	label_right_arrows[player].visible = true
	light[player].visible = true

func update_label_icon(player: int, action: String, color: Color, secondary_action: String):
	if player in label_icons:
		var label_icon: Label = label_icons[player]
		label_icon.text = action
		label_icon.add_theme_color_override("font_color", color)
	if player in secondary_label_icons:
		var secondary_label_icon: Label = secondary_label_icons[player]
		secondary_label_icon.text = secondary_action

func delete_player(player: int):
	if player in player_nodes:
		var player_node = player_nodes[player]
		player_node.reset()  # Assuming you have a reset method to clear the player state
		player_nodes.erase(player)
		update_label_icon(player, "xbox_button_a_outline", Color.GREEN, "to join")
		label_left_arrows[player].visible = false
		label_right_arrows[player].visible = false
		light[player].visible = false

func on_player_leave(player: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	loby_manager.leave(player)
