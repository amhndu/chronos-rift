extends Node

signal level_load(number: int)

@export var level_number: int

func _ready():
	#var game_manager: GameManager = get_tree().root.find_child("Main").find_child("GameManager")
	var game_manager: GameManager = get_tree().root.get_child(1).find_child("GameManager")
	level_load.connect(game_manager.on_level_loaded)
	level_load.emit(level_number)
