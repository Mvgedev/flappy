extends Node2D

var game_manager = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= game_manager.obs_speed * delta

func _on_body_entered(_body: Node) -> void:
	game_manager.add_score() # Replace with function body.
