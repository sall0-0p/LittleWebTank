extends Node2D
class_name BaseMovementController

@export var hull: BaseVehicle;

var _current_steering: float = 0.0;
var _current_throttle: float = 0.0;
	
func set_steering(steering: float) -> void:
	_current_steering = steering;
	var audio_controller = hull.vehicle_audio_controller;
	if (audio_controller):
		audio_controller.set_steering(steering);
	
func set_throttle(throttle: float) -> void:
	_current_throttle = throttle;
	var audio_controller = hull.vehicle_audio_controller;
	if (audio_controller):
		audio_controller.set_throttle(throttle);

func get_steering():
	return _current_steering;

func get_throttle():
	return _current_throttle;
