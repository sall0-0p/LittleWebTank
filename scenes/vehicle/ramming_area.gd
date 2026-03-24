extends Area2D

const ART_SCALE_FACTOR = 15;
@export var enabled: bool = true;
@export var required_speed: float = 5.0;

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if (enabled and body is BaseBuilding):
		var velocity = get_parent().velocity;
		var total_speed: float = sqrt(velocity.x**2 + velocity.y**2) / ART_SCALE_FACTOR;
		if (total_speed >= required_speed):
			body.handle_hit(body_shape_index);
