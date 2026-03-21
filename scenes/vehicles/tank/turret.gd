extends Node2D

const shell_scene = preload("res://scenes/shell/shell.tscn");

@export var traverse_speed: float = 10.0;
@export var shell_velocity: float = 40.0;

func _physics_process(delta: float) -> void:
	var traverse_speed_rad = deg_to_rad(traverse_speed) * delta;
	var target_angle = get_angle_to(get_global_mouse_position());
	var target_rotation = rotation + target_angle;
	rotation = move_toward(rotation, target_rotation, traverse_speed_rad);

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		# caclulate firing angle
		var facing = Vector2.from_angle(global_rotation)
		var length = (get_global_mouse_position() - global_position).length()
		var target_position = $MainGun.global_position + (facing * length);
		
		# create shell and launch it
		var shell = shell_scene.instantiate();
		shell.position = $MainGun.global_position
		shell.velocity = shell_velocity;
		shell.target_position = target_position;
		get_tree().root.add_child(shell);
