extends Node

@onready var player: RigidBody2D = %Player
@onready var obstacles: Node = $"../Obstacles"
@onready var border_right: Area2D = $"../Borders/BorderRight"

var OBSTACLES_PAIR = preload("res://scenes/obstacles_pair.tscn")
# Spawn y -80 to y 80 for obstacles

var game_start = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_obstacles()

func spawn_obstacles():
	var obsPair = OBSTACLES_PAIR.instantiate()
	obstacles.add_child(obsPair)
	#Define base position
	obsPair.position.x = border_right.position.x
	obsPair.position.y = randf_range(-80, 80)
