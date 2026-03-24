extends BaseMovementController

const ART_SCALE_FACTOR := 15.0;

@export_category("Driving")
@export var max_speed: float = 10.0;
@export var max_reverse: float = 3.5;
@export var acceleration: float = 2.5;
@export var friction: float = 3.5;
@export var turn_speed: float = 25;

var current_speed: float = 0;
func _physics_process(delta: float) -> void:
	var target_speed: float = 0;
	var turn_speed_rad: float = deg_to_rad(turn_speed);
	var rot: float = 0;
	
	if (_current_throttle > 0):
		target_speed = _current_throttle * max_speed;
	else:
		target_speed = _current_throttle * max_reverse;
	
	rot = _current_steering * delta * turn_speed_rad;
	
	# limit speed if rotating
	if (rot != target_speed):
		target_speed *= 0.6;
	
	# change rotation direction if reversing
	if (target_speed < 0):
		rot *= -1;

	hull.rotation += rot;
	
	# accelerate / decelerate
	var forward = Vector2.from_angle(get_parent().rotation);
	var relative_acceleration: float = 1.0 - current_speed / max_speed;
	var step_amount := 0.0;
	if (_current_throttle != 0):
		step_amount = acceleration * relative_acceleration * delta;
	else:
		step_amount = friction * delta;
	
	current_speed = move_toward(current_speed, target_speed, step_amount);
	hull.velocity = (current_speed * ART_SCALE_FACTOR) * forward;
	
	hull.move_and_slide();
