extends Line2D

func _ready() -> void:
	add_point(Vector2(0, 0));

func _process(_delta: float) -> void:
	visible = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if (visible):
		set_point_position(1, get_local_mouse_position());
