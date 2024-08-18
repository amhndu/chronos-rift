extends Node

signal mobs_all_clear

@onready var num_mobs_alive = get_children().size()

func on_mob_killed():
	num_mobs_alive -= 1
	if num_mobs_alive <= 0:
		mobs_all_clear.emit()

func on_game_restarted():
	for child in get_children():
		child.reset()
	num_mobs_alive = get_children().size()
