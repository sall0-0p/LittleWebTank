extends Sprite2D

var last_elevation = -99999;
var last_calculated_distance = 0;
var reticle_follow_speed = 2;
func _process(delta: float) -> void:
	visible = Input.is_action_pressed("aim");
	if (visible):
		var facing = Vector2.from_angle(rotation).rotated(deg_to_rad(-90));
		var parent = get_parent();
		
		var current_elevation = parent.elevation;
		if (abs(last_elevation - current_elevation) > 0.01):
			last_calculated_distance = parent.predict_landing(deg_to_rad(current_elevation));
			last_elevation = current_elevation;
			
		#position = facing * last_calculated_distance;
		var target_impact_position = facing * last_calculated_distance;
		position = position.lerp(target_impact_position, reticle_follow_speed * delta);
