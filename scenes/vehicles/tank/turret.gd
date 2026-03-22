extends Node2D

@export var traverse_speed: float = 10.0;

func _physics_process(delta: float) -> void:
	var traverse_speed_rad = deg_to_rad(traverse_speed) * delta;
	var target_angle = get_angle_to(get_global_mouse_position());
	var target_rotation = rotation + target_angle;
	rotation = move_toward(rotation, target_rotation, traverse_speed_rad);
