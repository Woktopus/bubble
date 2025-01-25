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
			boatNode.init(player, playerData[player]["device"])
			add_child(boatNode)
		else:
			print("Marker not found for player %d" % player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
