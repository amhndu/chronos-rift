extends Node

signal level_load

func _ready():
	level_load.emit()
