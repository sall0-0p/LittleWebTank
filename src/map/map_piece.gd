extends Sprite2D

func get_position_from_string(filename: String) -> Vector2i:
	print(filename)
	var number_string = filename.get_file().get_basename().trim_prefix("ASTM-tile")
	var x = number_string[0].to_int();
	var y = number_string[1].to_int();
	
	return Vector2i(x, y);

@export var texture_path: String = "":
	set(value):
		texture_path = value;
		if (value == ""):
			printerr("Failed to load this shit!");
			return
			
		texture = load(value);
		
		# get grid position out of filename
		var new_position = get_position_from_string(value);
		position = Vector2i(new_position.x * texture.get_width(), new_position.y * texture.get_height());
		print(new_position, position)
