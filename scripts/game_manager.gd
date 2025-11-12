extends Node

@onready var player: RigidBody2D = %Player
@onready var obstacles: Node = $"../Obstacles"
@onready var border_right: Area2D = $"../Borders/BorderRight"

#UI
@onready var score: Label = $"../CanvasLayer/Labels/Score"
@onready var best_score: Label = $"../CanvasLayer/Labels/Best Score"
@onready var instruction: Label = $"../CanvasLayer/Labels/Instruction"

@onready var game_over: Label = $"../CanvasLayer/UIPanel/TextureRect/GameOver"
@onready var recap_score: Label = $"../CanvasLayer/UIPanel/TextureRect/Recap score"
@onready var ui_panel: Control = $"../CanvasLayer/UIPanel"

#Landscape
@onready var parallax_foreground: Parallax2D = $"../Landscape/ParallaxForeground"
@onready var parallax_rocks: Parallax2D = $"../Landscape/ParallaxRocks"
@onready var parallax_tentacles: Parallax2D = $"../Landscape/ParallaxTentacles"

# SFX
@onready var explosion_sfx: AudioStreamPlayer2D = $"../SFX/Explosion"
@onready var loose_sfx: AudioStreamPlayer2D = $"../SFX/Loose"
@onready var score_sfx: AudioStreamPlayer2D = $"../SFX/ScoreSFX"


var OBSTACLES_PAIR = preload("res://scenes/obstacles_pair.tscn")
# Spawn y -80 to y 80 for obstacles

# Game values
var game_start = false
var obs_speed = 100
var foreground_speed = -70
var rocks_speed = -50
var tentacles_speed = -30


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreSystem.cur_score = 0
	ScoreSystem.connect("game_over", end_game)
	ScoreSystem.connect("explosion", defeat)
	ui_panel.visible = false
	#game_over.visible = false
	#recap_score.visible = false
	update_label()

func start_game():
	game_start = true
	instruction.visible = false
	player.gravity_scale = 1.0
	spawn_obstacles()
	await get_tree().create_timer(2.3).timeout
	spawn_obstacles()
	await get_tree().create_timer(2.3).timeout
	spawn_obstacles()

func defeat():
	explosion_sfx.play(0.0)

func end_game():
	loose_sfx.play(0.0)
	obs_speed = 0
	stop_parallax()
	player.dead = true
	score.visible = false
	best_score.visible = false
	recap_score.text = "Your score is " + str(ScoreSystem.cur_score) + "\nYour best score is " + str(ScoreSystem.pb_score)
	ui_panel.visible = true

	

func spawn_obstacles():
	var obsPair = OBSTACLES_PAIR.instantiate()
	obsPair.game_manager = self
	get_tree().current_scene.get_node("Obstacles").call_deferred("add_child", obsPair)
	#Define base position
	obsPair.position.x = border_right.position.x
	obsPair.position.y = randf_range(-80, 80)
	

func obstacle_speed_variant():
	var boost = ScoreSystem.cur_score * 10
	obs_speed = 100 + boost
	parallax_foreground.autoscroll = Vector2(foreground_speed + -boost, 0)
	parallax_rocks.autoscroll = Vector2(rocks_speed + -boost, 0)
	parallax_tentacles.autoscroll = Vector2(tentacles_speed + -boost, 0)
	

func stop_parallax():
	parallax_foreground.autoscroll = Vector2(0, 0)
	parallax_rocks.autoscroll = Vector2(0,0)
	parallax_tentacles.autoscroll = Vector2(0,0)

func _on_border_left_area_entered(area: Area2D) -> void:
	area.queue_free()
	spawn_obstacles()

func add_score():
	score_sfx.play(0.0)
	ScoreSystem.cur_score += 1
	if ScoreSystem.cur_score > ScoreSystem.pb_score:
		ScoreSystem.pb_score = ScoreSystem.cur_score
	update_label()
	if ScoreSystem.cur_score == 10 || ScoreSystem.cur_score == 20 || ScoreSystem.cur_score == 30:
		obstacle_speed_variant()


func update_label():
	score.text = "Score: " + str(ScoreSystem.cur_score)
	best_score.text = "Best score: " + str(ScoreSystem.pb_score)


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
