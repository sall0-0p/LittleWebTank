extends Node2D

const ART_SCALE_FACTOR := 15.0;

func _process(delta: float) -> void:
	visible = Input.is_action_pressed("aim");
	if (visible):
		var elevation = get_parent().target_elevation;
		var distance = (get_global_mouse_position() - get_parent().global_position).length() / ART_SCALE_FACTOR;
		
		position = get_global_mouse_position() + Vector2(15, 15);
		$Label.text = "%s\n%s°\n%sm" % [get_parent().ammo_type, snapped(elevation, 0.1), round(distance)];
