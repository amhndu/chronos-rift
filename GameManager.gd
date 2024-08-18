extends Object

signal score_update(score: int)
signal game_restart
signal game_end

var score = 0

func on_mob_killed():
	score += 100
	score_update.emit(score)

func on_player_hit():
	game_end.emit()

func on_restart_clicked():
	score = 0
	score_update.emit(score)
	game_restart.emit()

func on_mobs_all_cleared():
	game_end.emit()
