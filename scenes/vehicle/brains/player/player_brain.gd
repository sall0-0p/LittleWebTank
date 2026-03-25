extends Node2D
class_name PlayerBrain

signal swapped_unit(new_unit: BaseVehicle)

@export var available_units: Array[BaseVehicle] = []

var _controlled_unit_index: int = 0
var _controlled_unit: BaseVehicle

func _ready() -> void:
	if available_units.size() > 0:
		switch_unit(0)

func get_controlled_unit():
	return _controlled_unit;

func get_controlled_unit_index():
	return _controlled_unit_index;

func switch_unit(new_index: int) -> void:
	if available_units.is_empty():
		return
	
	if (_controlled_unit and _controlled_unit.movement_controller):
		var movement_controller: BaseMovementController = _controlled_unit.movement_controller
		movement_controller.set_steering(0);
		movement_controller.set_throttle(0);

	# Modulo (%) automatically loops the index back to 0 if it goes over the array size
	_controlled_unit_index = new_index % available_units.size()
	_controlled_unit = available_units[_controlled_unit_index]
	
	swapped_unit.emit(_controlled_unit)

func _physics_process(_delta: float) -> void:
	if not _controlled_unit:
		return
		
	global_position = _controlled_unit.global_position
	
	if _controlled_unit.movement_controller:
		# get_axis cleanly handles both positive and negative inputs in one line
		var throttle = Input.get_axis("move_backwards", "move_forward")
		var steering = Input.get_axis("move_left", "move_right")
		
		_controlled_unit.movement_controller.set_throttle(throttle)
		_controlled_unit.movement_controller.set_steering(steering)
		
		if _controlled_unit.weapon_controller:
			var is_manual_steering = abs(steering) > 0.0
			_controlled_unit.weapon_controller.set_manual_steering(is_manual_steering)

	if _controlled_unit.weapon_controller:
		var weapon_ctrl: WeaponController = _controlled_unit.weapon_controller
		
		if not weapon_ctrl.is_casemate or Input.is_action_pressed("aim"):
			weapon_ctrl.aim_active_weapon(get_global_mouse_position())
			
		var active_weapon: BaseWeapon = weapon_ctrl.get_active_weapon()
		if active_weapon:
			if active_weapon.firing_mode == BaseWeapon.FiringMode.AUTO and Input.is_action_pressed("fire"):
				weapon_ctrl.fire_active_weapon()
			elif active_weapon.firing_mode == BaseWeapon.FiringMode.SEMI and Input.is_action_just_pressed("fire"):
				weapon_ctrl.fire_active_weapon()

func _unhandled_input(event: InputEvent) -> void:
	if not _controlled_unit:
		return
		
	if event.is_action_pressed("next_vehicle"):
		if available_units.size() > 1:
			switch_unit(_controlled_unit_index + 1)
			
	if _controlled_unit.weapon_controller and event.is_action_pressed("swap_weapon"):
		var weapon_ctrl: WeaponController = _controlled_unit.weapon_controller
		if weapon_ctrl.available_weapons.size() > 1:
			var next_weapon = (weapon_ctrl.get_active_weapon_index() + 1) % weapon_ctrl.available_weapons.size()
			weapon_ctrl.switch_weapon(next_weapon)
