extends StaticBody2D
class_name BaseBuilding
enum DamageLevel { NORMAL, DAMAGED, RUBBLE }

@export var show_interior: bool:
	set(value):
		$Building.visible = not value;
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

# helpers
func _set_damage(damage: DamageLevel):
	z_index = 10;
	_set_collision_disabled(false);
	if (damage == DamageLevel.NORMAL):
		$Building.region_rect = Rect2(0, 0, 96, 96);
		$Interior.region_rect = Rect2(96, 0, 96, 96);
	if (damage == DamageLevel.DAMAGED):
		$Building.region_rect = Rect2(0, 96, 96, 96);
		$Interior.region_rect = Rect2(96, 0, 96, 96);
	if (damage == DamageLevel.RUBBLE):
		$Building.region_rect = Rect2(96, 96, 96, 96);
		$Interior.region_rect = Rect2(96, 96, 96, 96);
		z_index = -10;
		_set_collision_disabled(true);

func _set_collision_disabled(is_disabled: bool):
	for child in get_children():
		if (child is CollisionShape2D):
			child.set_deferred("disabled", is_disabled);

func _set_region_rect(part: Sprite2D, rect: Rect2):
	part.region_rect = rect;
