extends Node

var player_data: Dictionary = {}

enum PowerType{SPEED, HEALTH}

func reset_all()->void:
	player_data = {}
