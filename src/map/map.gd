extends Node2D

var map_piece_scene = preload("res://scenes/map/map_piece.tscn");
@export var path_to_folder: String = "":
	set(value):
		var files = DirAccess.get_files_at(value);
		
		for file in files:
			if file.begins_with("ASTM-tile") and file.ends_with(".jpg"):
				var new_cell = map_piece_scene.instantiate();
				add_child(new_cell)
				new_cell.texture_path = value + "/" + file;
