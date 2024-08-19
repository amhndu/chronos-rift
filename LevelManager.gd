extends Node

signal level_load

var levels = ["res://level_scenes/Level2.tscn"]
var first_preloaded = preload("res://level_scenes/Level2.tscn")

func _enter_tree():
	var instance = first_preloaded.instantiate()
	add_child(instance)

func _ready():
	level_load.emit()
