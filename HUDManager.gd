extends Node

@export var scoreLabel: Label
@export var finalScoreLabel: Label
@export var nextButton: Button
@export var restartButton: Button

var _score = 0

func on_score_updated(score: int):
	_score = score
	scoreLabel.set_text("Score: " + String.num(score))

func on_game_level_ended():
	restartButton.visible = true

func on_game_level_cleared():
	nextButton.visible = true
	restartButton.visible = true
	
func on_game_level_started():
	nextButton.visible = false
	restartButton.visible = false

func on_game_ended():
	nextButton.visible = false
	restartButton.visible = false
	scoreLabel.visible = false
	finalScoreLabel.set_text("You made it to the end!\nYour final score:\n"
		+ String.num(_score))
	finalScoreLabel.visible = true
