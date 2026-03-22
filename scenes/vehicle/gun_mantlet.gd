extends Node2D
class_name GunMantlet

@export var target_elevation: float = 0;
@export var max_elevation: float = 20.0;
@export var max_depression: float = -12.0;
@export var traverse_speed: float = 5;

@export var elevation: float = 0.0:
	get():
		return _elevation;
	set(value):
		pass;

var _elevation = 0.0;
func _physics_process(delta: float) -> void:
	var clamped_target = clamp(target_elevation, max_depression, max_elevation);
	_elevation = move_toward(_elevation, clamped_target, traverse_speed * delta);
