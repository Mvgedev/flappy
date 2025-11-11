extends RigidBody2D

@onready var game_manager: Node = %GameManager

var flap_force = -300
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if game_manager.game_start == false:
		gravity_scale = 0.0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Flap") and dead == false:
		if game_manager.game_start == false:
			game_manager.start_game()
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
		apply_central_impulse(Vector2(0, flap_force))
	 
