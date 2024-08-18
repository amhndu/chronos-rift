extends Node

func on_game_restarted():
	for child in get_children():
		child.reset()
