extends AnimatedSprite2D

func _ready() -> void:
	rotation = deg_to_rad(randf_range(1, 360));
	scale = scale * randf_range(0.9, 1.1);
	play("default");

func _on_animation_finished() -> void:
	queue_free();
