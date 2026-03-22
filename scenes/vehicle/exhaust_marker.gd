extends Marker2D

@export var enabled = true;

func _process(_delta: float) -> void:
	var parent_velocity = get_parent().velocity.x + get_parent().velocity.y
	if (abs(parent_velocity) < 5 or not enabled):
		$Emmissions.emitting = false;
	else:
		$Emmissions.emitting = true;
