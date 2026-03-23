extends BaseFuzeComponent

func _on_shell_impact(hit_object: Node2D, impact_point: Vector2, impact_normal: Vector2, pitch: float, shape_index: int):
	detonate.emit(hit_object, impact_point, impact_normal, pitch, shape_index);
