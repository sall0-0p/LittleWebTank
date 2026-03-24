extends Node2D
signal swapped_unit(new_unit: BaseVehicle);

@export var controlled_unit: BaseVehicle:
	get(): return _controlled_unit;
	set(value):
		if not is_node_ready():
			controlled_unit = value;
			_controlled_unit = value;
			return; 
		push_error("Cannot set controlled_unit, use switch_unit instead");

var _controlled_unit;
func switch_unit(new_unit: BaseVehicle):
	_controlled_unit = new_unit;
	swapped_unit.emit(new_unit);

func _physics_process(_delta: float) -> void:
	if (_controlled_unit):
		global_position = _controlled_unit.global_position;
		if (_controlled_unit.weapon_controller):
			_controlled_unit.weapon_controller.aim_active_weapon(get_global_mouse_position());

func _unhandled_input(event: InputEvent) -> void:
	if (_controlled_unit and _controlled_unit.movement_controller):
		if event.is_action_pressed("move_forward"):
			_controlled_unit.movement_controller.set_throttle(1);
		if event.is_action_released("move_forward"):
			_controlled_unit.movement_controller.set_throttle(0);
		if event.is_action_pressed("move_backwards"):
			_controlled_unit.movement_controller.set_throttle(-1);
		if event.is_action_released("move_backwards"):
			_controlled_unit.movement_controller.set_throttle(0);
			
		if event.is_action_pressed("move_left"):
			_controlled_unit.movement_controller.set_steering(-1);
		if event.is_action_released("move_left"):
			_controlled_unit.movement_controller.set_steering(0);
		if event.is_action_pressed("move_right"):
			_controlled_unit.movement_controller.set_steering(1);
		if event.is_action_released("move_right"):
			_controlled_unit.movement_controller.set_steering(0);
	
	if (_controlled_unit and _controlled_unit.weapon_controller) and event.is_action_pressed("fire"):
		_controlled_unit.weapon_controller.fire_active_weapon();
