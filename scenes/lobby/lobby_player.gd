extends Control

signal leave(player)

var player:int = -1
var input
var is_initialized:bool = false
var leave_check_delay:float = 0.5  # Delay in seconds before checking for leave action
var time_since_init:float = 0.0

var skins = []  # Array to hold the skin data
var current_skin_index = 0  # Index to track the current skin

# Reference to the lobby manager
@onready var loby_manager = get_node("/root/Lobby/LobyManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load all skin data into the skins array
	skins.append({"selection": load("res://assets/canard/Sprite-0001-Sheet.png"), "sprite": load("res://assets/canard/sprite_frame_canard.tres")})
	skins.append({"selection": load("res://assets/selection_canard_swap_1.png"), "sprite": load("res://assets/canard noir/sprite_frame_canard_noir.tres")})
	skins.append({"selection": load("res://assets/selection_drakkar_swap_1.png"), "sprite": load("res://assets/drakkar/drakkar.tres")})
	skins.append({"selection": load("res://assets/selection_canard_swap_2.png"), "sprite": load("res://assets/canard colvert/sprite_frame_canard_colvert.tres")})
	skins.append({"selection": load("res://assets/canard pirate/Sprite-0001-Shee22t.png"), "sprite": load("res://assets/canard pirate/sprite_frame_canard_pirate.tres")})
	skins.append({"selection": load("res://assets/selection_drakkar_swap_2.png"), "sprite":load("res://assets/canard/sprite_frame_canard.tres")})
	skins.append({"selection": load("res://assets/selection_drakkar_swap_3.png"), "sprite": load("res://assets/canard/sprite_frame_canard.tres")})

	# Add more skins as needed

func init(player_num:int, device:int):
	player = player_num
	input = DeviceInput.new(device)
	is_initialized = true
	time_since_init = 0.0
	$TextureRect.texture = skins[current_skin_index]["selection"]  # Set the initial skin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_initialized and player > -1:
		time_since_init += delta
		if time_since_init > leave_check_delay:
			if input.is_action_just_pressed("join"):
				print("leave")
				emit_signal("leave", player)
				return
		if input.is_action_just_pressed("left"):
			switch_skin(-1)
		if input.is_action_just_pressed("right"):
			switch_skin(1)

func switch_skin(direction: int) -> void:
	current_skin_index = (current_skin_index + direction) % skins.size()
	if current_skin_index < 0:
		current_skin_index = skins.size() - 1
	$TextureRect.texture = skins[current_skin_index]["selection"]
	
	# Update the player's skin data in the lobby manager
	loby_manager.set_player_skin(player, skins[current_skin_index]["sprite"].resource_path)

func reset() -> void:
	player = -1
	input = null
	is_initialized = false
	time_since_init = 0.0
	$TextureRect.texture = null
	current_skin_index = 0
