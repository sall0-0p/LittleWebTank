extends Node2D
class_name WeaponController
signal weapon_changed

@export var movement_controller: BaseMovementController;
@export var available_weapons: Array[BaseWeapon] = [];

var _active_weapon_index: int = 0;
var _active_weapon: BaseWeapon;

func _ready() -> void:
	switch_weapon(0);
	
func get_active_weapon() -> BaseWeapon:
	return _active_weapon;
	
func switch_weapon(index: int):
	if (index >= 0 and index < available_weapons.size()):
		_active_weapon_index = index;
		_active_weapon = available_weapons[index];
		
		weapon_changed.emit(_active_weapon.name);

func fire_active_weapon():
	if (_active_weapon != null):
		_active_weapon.try_fire();

func aim_active_weapon(target_position: Vector2) -> void:
	if _active_weapon == null:
		return;
	
	var turret = _active_weapon.turret;
	var mantlet = _active_weapon.mantlet;
	
	if turret:
		turret.target_position = target_position;
	if mantlet:
		mantlet.target_elevation = _active_weapon.get_firing_elevation(target_position);
