extends Node

signal score_update(score: int)
signal game_restart
signal game_end

var score = 0
var mob_manager: MobManager

func on_mob_killed():
	score += 100
	score_update.emit(score)

func on_player_hit():
	game_end.emit()

func on_restart_clicked():
	score = 0
	score_update.emit(score)
	mob_manager.on_game_restarted()
	game_restart.emit()

func on_mobs_all_cleared():
	game_end.emit()

func on_level_loaded():
	mob_manager = get_parent().find_child("Level").get_child(0).find_child("MobManager")
