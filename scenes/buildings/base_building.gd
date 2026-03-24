extends StaticBody2D
class_name BaseBuilding
enum DamageLevel { NORMAL, DAMAGED, RUBBLE }

const rubble_scene = preload("res://scenes/misc/rubble.tscn");

@export var show_interior: bool:
	set(value):
		if (damage_level != DamageLevel.RUBBLE):
			$Building.visible = not value;
		else:
			$Building.visible = true;
		show_interior = value;
			
@export var damage_level: DamageLevel = DamageLevel.NORMAL:
	set(value):
		damage_level = value;
		if not is_node_ready():
			return;
			
		_set_damage(value);

@export_category("Destruction & Ramming")
@export var is_reinforced: bool = false;
@export var max_structural_integrity: float = 100.0;
@export var damage_per_wall_destroyed: float = 15.0;
@export var damaged_at: float = 60.0;
@export var rubble_at: float = 0.0;

var structural_integrity = max_structural_integrity;

func _ready() -> void:
	$Interior.visible = true;
	$Building.visible = not show_interior;
	_set_damage(damage_level);

func handle_hit(shape_index: int): 
	var shape_owner_id = shape_find_owner(shape_index);
	var wall_node = shape_owner_get_owner(shape_owner_id);
	
	if (wall_node and wall_node is CollisionShape2D):
		if wall_node.disabled:
			return;
			
		wall_node.set_deferred("disabled", true);
		structural_integrity -= damage_per_wall_destroyed;
		
		if (structural_integrity < damaged_at and structural_integrity > rubble_at):
			_set_damage(DamageLevel.DAMAGED);
		if (structural_integrity < rubble_at):
			_set_damage(DamageLevel.RUBBLE);
		
		_spawn_rubble(wall_node);

# helpers
func _spawn_rubble(wall_node):
	# learn direction of a wall
	var wall_size: Vector2 = wall_node.shape.size;
	var is_horizontal: bool = wall_size.x > wall_size.y;
	
	var length: float = wall_size.x if is_horizontal else wall_size.y;
	var thickness: float = wall_size.y if is_horizontal else wall_size.x;
	
	var target_rubble_diameter: float = thickness * 3;
	var patch_count: int = max(1, round(length / (target_rubble_diameter / 2)));
	
	var dummy_rubble = rubble_scene.instantiate();
	var tex_size: Vector2 = dummy_rubble.texture.get_size();
	var tex_max: float = max(tex_size.x, tex_size.y);
	var base_scale: float = target_rubble_diameter / tex_max;
	dummy_rubble.queue_free();
	
	var start_offset: float = -length / 2.0;
	var step_size: float = length / float(patch_count);
	var wall_transform = wall_node.transform;
	
	for i in range(patch_count):
		var rubble = rubble_scene.instantiate();
		var current_pos: float = start_offset + (i * step_size) + (step_size / 2.0);
		
		var scatter_x = randf_range(-step_size * 0.2, step_size * 0.2);
		var scatter_y = randf_range(-thickness * 0.2, thickness * 0.2);
		
		var local_pos = Vector2.ZERO;
		if is_horizontal:
			local_pos = Vector2(current_pos + scatter_x, scatter_y);
		else:
			local_pos = Vector2(scatter_x, current_pos + scatter_y);
		
		rubble.position = wall_transform * local_pos;
		rubble.rotation = randf_range(0, TAU);
		
		var random_scale = base_scale * randf_range(0.8, 1.2);
		rubble.scale = Vector2(random_scale, random_scale);
		
		add_child(rubble);
	
func _set_damage(damage: DamageLevel):
	z_index = 10;
	if (damage == DamageLevel.NORMAL):
		$Building.visible = not show_interior;
		$Building.region_rect = Rect2(0, 0, 96, 96);
		$Interior.region_rect = Rect2(96, 0, 96, 96);
	if (damage == DamageLevel.DAMAGED):
		$Building.visible = not show_interior;
		$Building.region_rect = Rect2(0, 96, 96, 96);
		$Interior.region_rect = Rect2(96, 0, 96, 96);
	if (damage == DamageLevel.RUBBLE):
		$Building.region_rect = Rect2(96, 96, 96, 96);
		$Interior.region_rect = Rect2(96, 96, 96, 96);
		$Building.visible = true;
		z_index = -10;
		_set_collision_disabled(true);

func _set_collision_disabled(is_disabled: bool):
	for child in get_children():
		if (child is CollisionShape2D):
			child.set_deferred("disabled", is_disabled);
