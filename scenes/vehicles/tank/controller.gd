extends CharacterBody2D

const ART_SCALE_FACTOR := 15.0;

@export var max_speed: float = 10.0;
@export var max_reverse: float = 3.5;
@export var acceleration: float = 1.2;
@export var friction: float = 3.5;
@export var turn_speed: float = 2;

var current_speed_ms: float = 0;

func _physics_process(delta: float) -> void:
	var target_speed: float = 0;
	var turn_speed_rad = deg_to_rad(turn_speed)
	var rot: float = 0;
	
	if Input.is_action_pressed("move_forward"):
		target_speed = max_speed;
		
	if Input.is_action_pressed("move_backwards"):
		target_speed = -max_reverse;
		
	if Input.is_action_pressed("move_right"):
		rot += turn_speed_rad * delta;
	
	if Input.is_action_pressed("move_left"):
		rot += turn_speed_rad * delta * -1;
	
	# if turning, penalise the vehicle speed
	if (rot != 0):
		target_speed *= 0.6;
		
	if (target_speed < 0):
		rot *= -1;
		
	# rotate the vehicle
	rotation += rot;
	
	# acceleration / deceleration logic
	var forward = Vector2.from_angle(rotation);
	var relative_acceleration: float = 1.0 - current_speed_ms / max_speed;
	var step_amount := 0.0;
	if (step_amount != 0):
		step_amount = acceleration * relative_acceleration * delta;
	else:
		step_amount = friction * delta;
	
	current_speed_ms = move_toward(current_speed_ms, target_speed, step_amount);
	velocity = (current_speed_ms * ART_SCALE_FACTOR) * forward;
	
	move_and_slide()
