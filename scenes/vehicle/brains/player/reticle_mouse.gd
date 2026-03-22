extends Sprite2D

func _process(_delta: float) -> void:
	visible = Input.is_action_pressed("aim");
	if (visible):
		global_position = get_global_mouse_position();

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("aim")):
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	if (event.is_action_released("aim")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
