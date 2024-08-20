extends Node
class_name MobManager
signal mobs_all_clear

@onready var num_mobs_alive = get_children().size()

func _ready():
	#var game_manager: GameManager = get_tree().root.find_child("Main").find_child("GameManager")
	var game_manager: GameManager = get_tree().root.get_child(1).find_child("GameManager")
	mobs_all_clear.connect(game_manager.on_mobs_all_cleared)
	
	var player: Player = get_tree().root.get_child(1).find_child("PlayerAstronaut")
	player.mob_kill.connect(on_mob_killed)

func on_mob_killed():
	num_mobs_alive -= 1
	if num_mobs_alive <= 0:
		mobs_all_clear.emit()

func on_game_level_restarted():
	for child in get_children():
		child.reset()
	num_mobs_alive = get_children().size()
