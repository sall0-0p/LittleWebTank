extends Resource
class_name ProjectileData

@export var name: String = "Default Shell";
@export var muzzle_velocity: float = 800.0;
@export var mass: float = 7.0;
@export var caliber: float = 76.2;
@export var drag_coefficient: float = 0.3;
@export var aiming_tolerance: float = 1.0;
@export var shell_scene: PackedScene;
