extends Node2D

var boatscene = preload("res://scenes/boat/boat.tscn")

var reset_timer: Timer

var isResetNotTimerLaunched = true
var num_player : int = 0

var player1_present : bool = false
var player2_present : bool = false
var player3_present : bool = false
var player4_present : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	reset_timer = Timer.new()
	reset_timer.one_shot = true
	reset_timer.timeout.connect(jpp)
	add_child(reset_timer)
	
	var playerData = GameData.player_data
	print(playerData)
	for player in playerData:
		if player == 0:
			player1_present = true
		if player == 1:
			player2_present = true
		if player == 2:
			player3_present = true
		if player == 3:
			player4_present = true
	#check if player 1 is present in game 
	if player1_present :
		$GUI/Player1Hud.set_player_libelle(str("Player 1"))
		$GUI/Player1Hud.set_player_icone(playerData[0]["icone"])
	else :
		$GUI/Player1Hud.visible = false
		
	#check if player 2 is present in game 
	if player2_present :
		$GUI/Player2Hud.set_player_libelle(str("Player 2"))
		$GUI/Player2Hud.set_player_icone(playerData[1]["icone"])
	else :
		$GUI/Player2Hud.visible = false
	
	#check if player 3 is present in game 
	if player3_present :
		$GUI/Player3Hud.set_player_libelle(str("Player 2"))
		$GUI/Player3Hud.set_player_icone(playerData[2]["icone"])
	else :
		$GUI/Player3Hud.visible = false
	
	#check if player 4 is present in game 
	if player4_present :
		$GUI/Player4Hud.set_player_libelle(str("Player 2"))
		$GUI/Player4Hud.set_player_icone(playerData[3]["icone"])
	else :
		$GUI/Player4Hud.visible = false
		
	
	for player in playerData:
		var marker_name = "markerp" + str(player + 1)
		var marker = get_node(marker_name)
		if marker:
			# init boat 
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
	var id_winner = check_players_state()
	#id_winner =-1 #todelete
	if id_winner != -1 && isResetNotTimerLaunched: 
		var id_display_winner = id_winner+1
		var txt_winner = "Joueur "+str(id_display_winner)+" a gagné !!"
		$WinnerPanel.setup_text(txt_winner)
		$WinnerPanel.visible=true
		reset_timer.start(5.0)
		isResetNotTimerLaunched = false
	update_players_gui()
		
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
	
func update_players_gui():
	var boats = get_tree().get_nodes_in_group("boat")
	for boat : Player in boats :
		if boat.player == 0 :
			$GUI/Player1Hud.update_life_bar(boat.get_player_health())
		if boat.player == 1 :
			$GUI/Player2Hud.update_life_bar(boat.get_player_health())
		if boat.player == 2 :
			$GUI/Player3Hud.update_life_bar(boat.get_player_health())
		if boat.player == 3 :
			$GUI/Player4Hud.update_life_bar(boat.get_player_health())
			
	pass
	
func jpp():
	print("end")
	get_tree().change_scene_to_file("res://scenes/lobby/lobby.tscn")
