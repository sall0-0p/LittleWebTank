extends Node2D
class_name BaseTurret

@export var target_position: Vector2 = Vector2.ZERO;
@export var traverse_speed: float = 5.0;
@export var minimum_traverse: float = -360;
@export var maximum_traverse: float = 360;

@export var remaining_error: float = 0:
	get():
		return _remaining_error;
	set(value):
		pass;

var _remaining_error: float = 0.0;
func _physics_process(delta: float) -> void:
	var minimum_traverse_rad = deg_to_rad(minimum_traverse);
	var maximum_traverse_rad = deg_to_rad(maximum_traverse);
	var traverse_speed_rad = deg_to_rad(traverse_speed) * delta;
	
	var target_angle = get_angle_to(target_position);
	var target_rotation = rotation + target_angle;
	var clamped_rotation = clamp(target_rotation, minimum_traverse_rad, maximum_traverse_rad);
	
	_remaining_error = target_rotation - clamped_rotation;
	rotation = move_toward(rotation, clamped_rotation, traverse_speed_rad);
