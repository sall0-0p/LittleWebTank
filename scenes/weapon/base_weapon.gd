extends Sprite2D;
class_name BaseWeapon;
signal weapon_fired;
signal weapon_reloaded;
enum FiringMode { AUTO, SEMI };

@export var trunnion_height: float = 2.0;
@export_category("Firing")
@export var magazine_capacity: int = 1;
@export var base_spread_degrees: float = 1.5;
@export var fire_rate_delay: float = 0.2;
@export var firing_mode: FiringMode = FiringMode.SEMI;
@export var ammo_type: ProjectileData;
@export_category("Components")
@export var solver: BaseWeaponSolver;
@export var mantlet: GunMantlet;
@export var turret: BaseTurret;

var can_fire: bool = true;
var reloading: bool = false;
var shots_left: int;
func _ready() -> void:
	shots_left = magazine_capacity;

func get_firing_elevation(target_position: Vector2) -> float:
	var distance = abs((global_position - target_position).length());
	return solver.calculate_elevation(distance, ammo_type.aiming_tolerance);

func get_current_impact() -> Vector2:
	var distance = solver.predict_impact_distance(deg_to_rad(mantlet.elevation));
	var forward_direction = Vector2.from_angle(turret.global_rotation)
	var impact_global_position = global_position + (forward_direction * distance);
	return impact_global_position;
	
func try_fire() -> bool:
	if (not can_fire):
		return false;
	
	shots_left -= 1;
	weapon_fired.emit();
	$ShootingAudioProxy.play();
	if (fire_rate_delay > 0):
		can_fire = false;
		await get_tree().create_timer(fire_rate_delay).timeout;
		can_fire = true;
	
	if (shots_left <= 0):
		reload();
	
	return true;

# reloading logic
func get_ammo_count() -> int:
	return 100;

func reload():
	can_fire = false;
	reloading = true;
	$ReloadingAudio.play();
	$Timer.wait_time = ammo_type.base_reload_time;
	$Timer.start();

func _on_timer_timeout() -> void:
	shots_left = magazine_capacity;
	weapon_reloaded.emit();
	can_fire = true;
	reloading = false;

func get_ammo_in_magazine() -> int:
	return shots_left;

func can_gun_fire():
	return can_fire;

func is_reloading():
	return reloading;

func get_reloading_time_left():
	return $Timer.time_left;
