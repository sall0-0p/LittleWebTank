extends Node2D
class_name BaseMovementComponent

var _current_steering: float = 0.0;
var _current_throttle: float = 0.0;
	
func set_steering(steering: float) -> void:
	_current_steering = steering;
	
func set_throttle(throttle: float) -> void:
	_current_throttle = throttle;
