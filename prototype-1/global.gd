extends Node

var last_level_path: String = "res://level_1.tscn"
var touch_controls_visible: bool = true

var score: int = 0:
	set(value):
		score = value
		# Emit a signal whenever score changes so UI can listen to it
		score_changed.emit(score)

signal score_changed(new_score)

func add_score(amount: int) -> void:
	score += amount
