extends Node2D
class_name TurretAudioController

@export var is_turret_traversing: bool = false:
	set(value):
		$TurretTraverse.playing = value;

func _ready() -> void:
	$TurretTraverse.stream.loop = true;
