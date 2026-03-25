extends Node2D
class_name WeaponController
signal weapon_changed

@export var movement_controller: BaseMovementController;
@export var available_weapons: Array[BaseWeapon] = [];
@export var is_casemate: bool = false;

var _is_steering_manually: bool = false;
var _active_weapon_index: int = 0;
var _active_weapon: BaseWeapon;

func _ready() -> void:
	switch_weapon(0);
	
func get_active_weapon() -> BaseWeapon:
	return _active_weapon;

func get_active_weapon_index() -> int:
	return _active_weapon_index;
	
func switch_weapon(index: int):
	if (index >= 0 and index < available_weapons.size()):
		_active_weapon_index = index;
		_active_weapon = available_weapons[index];
		
		weapon_changed.emit(_active_weapon.name);

func fire_active_weapon():
	if (_active_weapon != null):
		_active_weapon.try_fire();

func set_manual_steering(ms: bool):
	_is_steering_manually = ms;

func aim_active_weapon(target_position: Vector2) -> void:
	if _active_weapon == null:
		return;
	
	var turret = _active_weapon.turret;
	var mantlet = _active_weapon.mantlet;

	if turret:
		turret.target_position = target_position;
		if (is_casemate and not _is_steering_manually):
			var dir_to_target = global_position.direction_to(target_position);
			var angle_to_target = dir_to_target.angle();
			var angle_diff = angle_difference(global_rotation, angle_to_target);
			var turn_threshold = deg_to_rad(8.0);
			
			# 1 means false, -1 means true;
			var isReversing: int = 1;
			if (movement_controller.get_throttle() < 0):
				isReversing = -1;
			
			if angle_diff > turn_threshold:
				movement_controller.set_steering(1 * isReversing);
			elif angle_diff < -turn_threshold:
				movement_controller.set_steering(-1 * isReversing);
			else:
				movement_controller.set_steering(0);
	
	if mantlet:
		mantlet.target_elevation = _active_weapon.get_firing_elevation(target_position);
