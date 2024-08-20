extends Node

#signal level_load

var first = preload("res://level_scenes/Level1.tscn")
var second = preload("res://level_scenes/Level2.tscn")
var levels = [first, second]
var current_level_index = 0

func _enter_tree():
	var instance = levels[current_level_index].instantiate()
	add_child(instance)

func on_game_level_next():
	if (current_level_index >= levels.size()):
		return
	current_level_index += 1
	get_child(0).free()
	var instance = levels[current_level_index].instantiate()
	add_child(instance)
