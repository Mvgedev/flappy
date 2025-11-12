extends Node

var cur_score = 0
var pb_score = 0

signal game_over()
signal explosion()


const SAVE_FILE = "user://savegame.save"

func _ready() -> void:
	load_score()

func save_score():
	var score_data = {"pb_score" : pb_score}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(score_data))
	file.close()

func load_score():
	if not FileAccess.file_exists(SAVE_FILE):
		return
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY and data.has("pb_score"):
		pb_score = data["pb_score"] as int

func end_game():
	emit_signal("explosion")
	var timer = get_tree().create_timer(0.5)
	Engine.time_scale = 0.5
	await timer.timeout
	Engine.time_scale = 1
	emit_signal("game_over")
	save_score()
