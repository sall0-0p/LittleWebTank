extends AnimatedSprite2D

@export var explosion_scale: float = 1.0;
@export var scale_randomisation: float = 0.2;

func _ready() -> void:
	var randomised = randf_range(explosion_scale - (scale_randomisation / 2), explosion_scale + (scale_randomisation / 2));
	scale = Vector2(explosion_scale, explosion_scale) * randomised;
	rotation = deg_to_rad(randf_range(1, 360));
	speed_scale = randf_range(0.8, 1.25);
	play("default");

func _on_animation_finished() -> void:
	queue_free();
