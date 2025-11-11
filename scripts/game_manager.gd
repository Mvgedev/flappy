extends Node

@onready var player: RigidBody2D = %Player
@onready var obstacles: Node = $"../Obstacles"
@onready var border_right: Area2D = $"../Borders/BorderRight"

#Labels
@onready var score: Label = $"../Labels/Score"
@onready var best_score: Label = $"../Labels/Best Score"
@onready var instruction: Label = $"../Labels/Instruction"
@onready var game_over: Label = $"../Labels/GameOver"
@onready var recap_score: Label = $"../Labels/Recap score"


var OBSTACLES_PAIR = preload("res://scenes/obstacles_pair.tscn")
# Spawn y -80 to y 80 for obstacles

# Game values
var game_start = false
var obs_speed = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreSystem.cur_score = 0
	ScoreSystem.connect("game_over", end_game)
	game_over.visible = false
	recap_score.visible = false
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

func end_game():
	obs_speed = 0
	player.dead = true
	score.visible = false
	best_score.visible = false
	game_over.visible = true
	recap_score.text = "Your score is: " + str(ScoreSystem.cur_score) + "\nYour best score is: " + str(ScoreSystem.pb_score)
	recap_score.visible = true

func spawn_obstacles():
	var obsPair = OBSTACLES_PAIR.instantiate()
	obsPair.game_manager = self
	get_tree().current_scene.get_node("Obstacles").call_deferred("add_child", obsPair)
	#Define base position
	obsPair.position.x = border_right.position.x
	obsPair.position.y = randf_range(-80, 80)
	

func obstacle_speed_variant():
	obs_speed = 100 + ScoreSystem.cur_score * 10
	

func _on_border_left_area_entered(area: Area2D) -> void:
	area.queue_free()
	spawn_obstacles()

func add_score():
	ScoreSystem.cur_score += 1
	if ScoreSystem.cur_score > ScoreSystem.pb_score:
		ScoreSystem.pb_score = ScoreSystem.cur_score
	update_label()
	if ScoreSystem.cur_score == 10 || ScoreSystem.cur_score == 20 || ScoreSystem.cur_score == 30:
		obstacle_speed_variant()


func update_label():
	score.text = "Score: " + str(ScoreSystem.cur_score)
	best_score.text = "Best score: " + str(ScoreSystem.pb_score)
