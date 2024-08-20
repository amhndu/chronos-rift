extends Node
class_name GameManager

signal score_update(score: int)
signal game_level_restart # when restart button clicked
signal game_level_end # due to player death
signal game_level_clear # killed all mobs
signal game_level_next # when next level button clicked
signal game_end # last level cleared

var score = 0
var score_last_level = 0
var mob_manager: MobManager
var is_last_level = false

func on_mob_killed():
	score += 100
	score_update.emit(score)

func on_player_hit():
	game_level_end.emit()

func on_restart_clicked():
	score = score_last_level
	score_update.emit(score)
	mob_manager.on_game_level_restarted()
	game_level_restart.emit()

func on_next_clicked():
	score_last_level = score
	game_level_next.emit()

func on_mobs_all_cleared():
	if is_last_level:
		game_end.emit()
	else:
		game_level_clear.emit()

func on_level_loaded(number: int, is_last_level: bool):
	mob_manager = get_parent().find_child("Level").get_child(0).find_child("MobManager")
	self.is_last_level = is_last_level
