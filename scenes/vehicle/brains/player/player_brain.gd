extends Node2D

@export var movement_component: BaseMovementComponent;
@export var weapon_controller: WeaponController;

func _physics_process(_delta: float) -> void:
	weapon_controller.aim_active_weapon(get_global_mouse_position());

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		movement_component.set_throttle(1);
	if event.is_action_released("move_forward"):
		movement_component.set_throttle(0);
	if event.is_action_pressed("move_backwards"):
		movement_component.set_throttle(-1);
	if event.is_action_released("move_backwards"):
		movement_component.set_throttle(0);
		
	if event.is_action_pressed("move_left"):
		movement_component.set_steering(-1);
	if event.is_action_released("move_left"):
		movement_component.set_steering(0);
	if event.is_action_pressed("move_right"):
		movement_component.set_steering(1);
	if event.is_action_released("move_right"):
		movement_component.set_steering(0);
		
	if event.is_action_pressed("fire"):
		weapon_controller.fire_active_weapon();
