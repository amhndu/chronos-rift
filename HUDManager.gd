extends Node

@export var scoreLabel: Label
@export var restartButton: Button

func on_score_updated(score: int):
	scoreLabel.set_text("Score: " + String.num(score))

func on_game_ended():
	restartButton.visible = true
	
func on_game_restarted():
	restartButton.visible = false
