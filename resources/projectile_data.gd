extends Resource
class_name ProjectileData

@export var name: String = "Default Shell";
@export var muzzle_velocity: float = 800.0;
@export var mass: float = 7.0;
@export var caliber: float = 76.2;
@export var drag_coefficient: float = 0.3;
@export var aiming_tolerance: float = 1.0;
@export var arming_distance: float = 3;
@export var base_reload_time: float = 4.5;
@export var spread_multiplier: float = 1.0;
@export var warhead_effect_multiplier: float = 1.0;
@export var shell_scene: PackedScene;
