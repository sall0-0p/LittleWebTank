extends Area2D

const ART_SCALE_FACTOR := 15.0;
const explosion_scene = preload("res://scenes/shell/explosion.tscn");

@export var target_position: Vector2 = Vector2.ZERO;
@export var velocity: float = 40;

func explode():
	var explosion = explosion_scene.instantiate();
	explosion.global_position = global_position;
	get_tree().root.add_child(explosion);
	queue_free();

func _physics_process(delta: float) -> void:
	look_at(target_position);
	global_position = global_position.move_toward(target_position, velocity * ART_SCALE_FACTOR * delta);
	if (global_position == target_position):
		explode();
