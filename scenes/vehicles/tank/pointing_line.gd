extends Line2D

func _ready() -> void:
	add_point(Vector2(0, 0));

func _process(_delta: float) -> void:
	visible = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if (visible):
		var facing = Vector2.from_angle(rotation).rotated(deg_to_rad(90));
		var length = (get_local_mouse_position() - Vector2.ZERO).length()
		set_point_position(1, facing * -length);
