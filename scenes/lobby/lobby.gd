extends Node

# this is a singleton autoload in my project but for the purposes of this demo,
# this is simpler
@onready var loby_manager = $LobyManager

# map from player integer to the player node
var player_nodes = {}

func _ready():
	GameData.reset_all()
	loby_manager.player_joined.connect(spawn_player)
	loby_manager.player_left.connect(delete_player)

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
		var node = $Control/MarginContainer/GridContainer.get_child(i).get_child(0)
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

func delete_player(player: int):
	if player in player_nodes:
		var player_node = player_nodes[player]
		player_node.reset()  # Assuming you have a reset method to clear the player state
		player_nodes.erase(player)

func on_player_leave(player: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	loby_manager.leave(player)
