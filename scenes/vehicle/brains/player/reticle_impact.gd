extends Sprite2D

@export var player_brain: Node2D;

var target_position = Vector2.ZERO;
func _process(delta: float) -> void:
	visible = Input.is_action_pressed("aim");
	if (visible):
		if (player_brain and player_brain.controlled_unit):
			var weapon_controller: WeaponController = player_brain.controlled_unit.weapon_controller;
			var weapon: BaseWeapon = weapon_controller.get_active_weapon();
			target_position = weapon.get_current_impact();
			if (abs((target_position - get_global_mouse_position()).length()) < 60):
				target_position = get_global_mouse_position();
			global_position = global_position.lerp(target_position, 2.5 * delta);
		
	
