extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Map.path_to_folder = "res://assets/map/ASTM";
	print("Up and Running!");
