extends Node2D

var boatscene = preload("res://scenes/boat/boat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var playerData = GameData.player_data
	for player in playerData:
		var marker_name = "markerp" + str(player + 1)
		var marker = get_node(marker_name)
		if marker:
			var boatNode = boatscene.instantiate()
			boatNode.position = marker.position
			boatNode.init(playerData[player]["device"], player, playerData[player]["skin"])
			add_child(boatNode)
			boatNode.add_to_group("boat")
		else:
			print("Marker not found for player %d" % player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# check player health
	#var boats = get_tree().get_nodes_in_group("boat")
	pass

# return id player who win or -1
func check_players_state() -> int :
	var return_value = -1
	var boats = get_tree().get_nodes_in_group("boat")
	for boat in boats :
		pass
	
	
	return return_value
	
	
	
