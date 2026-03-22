extends Marker2D

func _process(_delta: float) -> void:
	var target_position: Vector2;
	if (Input.is_action_pressed("aim")):
		target_position = get_local_mouse_position() * 1.5;
	else:
		target_position = Vector2.ZERO;
		
	position = lerp(position, target_position, 0.04);
