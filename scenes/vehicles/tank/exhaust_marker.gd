extends Marker2D

func _process(_delta: float) -> void:
	if (get_parent().velocity.x < 1 and get_parent().velocity.y < 1):
		$Emmissions.emitting = false;
	else:
		$Emmissions.emitting = true;
