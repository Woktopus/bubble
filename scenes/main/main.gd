extends Node2D

var boatscene = preload("res://scenes/boat/boat.tscn")

var reset_timer: Timer

var isResetNotTimerLaunched = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	reset_timer = Timer.new()
	reset_timer.one_shot = true
	reset_timer.timeout.connect(jpp)
	add_child(reset_timer)
	
	var playerData = GameData.player_data
	for player in playerData:
		var marker_name = "markerp" + str(player + 1)
		var marker = get_node(marker_name)
		if marker:
			var boatNode = boatscene.instantiate()
			boatNode.position = marker.position
			boatNode.init(playerData[player]["device"], player)
			add_child(boatNode)
			boatNode.add_to_group("boat")
		else:
			print("Marker not found for player %d" % player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# check player health
	var id_winner = check_players_state()
	if id_winner != -1 && isResetNotTimerLaunched: 
		var id_display_winner = id_winner+1
		var txt_winner = "Joueur "+str(id_display_winner)+" a gagné !! Reset dans 10 secondes"
		$WinnerPanel.setup_text(txt_winner)
		$WinnerPanel.visible=true
		reset_timer.start(4.0)
		isResetNotTimerLaunched = false
		
		
	#var boats = get_tree().get_nodes_in_group("boat")
	pass

# return id player who win or -1
func check_players_state() -> int :
	var return_value = -1
	var boats = get_tree().get_nodes_in_group("boat")
	var more_than_one : bool = false
	for boat : Player in boats :
		if boat.is_alive :
			if return_value == -1 :
				return_value = boat.player
			else :
				more_than_one = true
	if more_than_one :
		return_value = -1
	return return_value
	
func jpp():
	print("end")
	get_tree().change_scene_to_file("res://scenes/lobby/lobby.tscn")
