extends Sprite2D;
class_name BaseWeapon;
signal weapon_fired;

@export var solver: BaseWeaponSolver;
@export var mantlet: GunMantlet;
@export var turret: BaseTurret;
@export var trunnion_height: float = 2.0;
@export var ammo_type: ProjectileData;

func get_firing_elevation(target_position: Vector2) -> float:
	var distance = abs((global_position - target_position).length());
	return solver.calculate_elevation(distance, ammo_type.aiming_tolerance);

func get_current_impact() -> Vector2:
	var distance = solver.predict_impact_distance(deg_to_rad(mantlet.elevation));
	var forward_direction = Vector2.from_angle(turret.global_rotation)
	var impact_global_position = global_position + (forward_direction * distance);
	return impact_global_position;
	
func try_fire() -> bool:
	weapon_fired.emit();
	return true;

func get_ammo_count() -> int:
	return 100;
