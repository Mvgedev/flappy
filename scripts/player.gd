extends RigidBody2D

var gravity_affect = false
var flap_force = -300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#gravity_scale = 0.0
	pass

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Flap"):
		print("Flap")
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
		apply_central_impulse(Vector2(0, flap_force))
	 
