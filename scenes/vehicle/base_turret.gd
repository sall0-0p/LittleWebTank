extends Node2D
class_name BaseTurret

@export_category("Traverse")
@export var target_position: Vector2 = Vector2.ZERO;
@export var traverse_speed: float = 5.0;
@export var minimum_traverse: float = -INF;
@export var maximum_traverse: float = INF;
@export var traverse_tolerance: float = 0.1;

var _remaining_error: float = 0.0;
func _ready() -> void:
	target_position = global_position + Vector2.RIGHT * global_rotation;

func _physics_process(delta: float) -> void:
	var minimum_traverse_rad = deg_to_rad(minimum_traverse);
	var maximum_traverse_rad = deg_to_rad(maximum_traverse);
	var traverse_speed_rad = deg_to_rad(traverse_speed) * delta;
	var tolerance_rad = deg_to_rad(traverse_tolerance);
	
	var target_angle = get_angle_to(target_position);
	var target_rotation = rotation + target_angle;
	var clamped_rotation = clamp(target_rotation, minimum_traverse_rad, maximum_traverse_rad);
	
	_remaining_error = target_rotation - clamped_rotation;
	
	var distance_to_target = abs(clamped_rotation - rotation);
	if distance_to_target > tolerance_rad:
		rotation = move_toward(rotation, clamped_rotation, traverse_speed_rad);
		
		if not $TurretTraverseAudio.playing:
			$TurretTraverseAudio.playing = true;
	else:
		rotation = clamped_rotation;
		
		if $TurretTraverseAudio.playing:
			$TurretTraverseAudio.playing = false;

func get_remaining_error():
	return _remaining_error;

func get_current_rotation():
	return rad_to_deg(rotation);
