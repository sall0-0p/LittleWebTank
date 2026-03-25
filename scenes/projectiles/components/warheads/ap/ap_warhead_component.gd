extends BaseWarheadComponent

func detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float, current_velocity: Vector3, shape_index: int):
	get_parent().queue_free();
	
