extends Sprite2D

var last_hovered_building: BaseBuilding;
func _process_building_hover():
	# hide building if under mouse
	var space = get_world_2d().direct_space_state;
	var query = PhysicsPointQueryParameters2D.new();
	query.position = get_global_mouse_position();
	query.collision_mask = 3;
	query.collide_with_bodies = false;
	query.collide_with_areas = true;

	# check for things at certain point;
	var results = space.intersect_point(query);
	if (results.size() > 0):
		var result = results[0];
		var area = result.collider;
		var building = area.get_parent();
		
		print(last_hovered_building == building)
		if building is BaseBuilding:
			if (last_hovered_building == building):
				return;
			
			if (last_hovered_building):
				last_hovered_building.show_interior = false;
			
			last_hovered_building = building;
			last_hovered_building.show_interior = true;
			return;
	
	# if no building is detected, remove one that we are currently hovering over.
	if (last_hovered_building):
		last_hovered_building.show_interior = false;
		last_hovered_building = null;

func _process(_delta: float) -> void:
	visible = Input.is_action_pressed("aim");
	if (visible):
		global_position = get_global_mouse_position();
		_process_building_hover();

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("aim")):
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	if (event.is_action_released("aim")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		if (last_hovered_building):
			last_hovered_building.show_interior = false;
			last_hovered_building = null;
