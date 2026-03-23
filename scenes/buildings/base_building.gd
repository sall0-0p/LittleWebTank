extends StaticBody2D
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
@export var damaged_at: float = 15.0;

func _ready() -> void:
	$Building.visible = not show_interior;
	_set_damage(damage_level);

func handle_hit(hit_collider: Node): 
	if (hit_collider is CollisionShape2D):
		hit_collider.set_deferred("disabled", true);

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
