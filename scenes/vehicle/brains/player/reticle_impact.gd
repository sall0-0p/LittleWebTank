extends Sprite2D

var target_position = Vector2.ZERO;
func _process(delta: float) -> void:
	var weapon_controller: WeaponController = get_parent().weapon_controller;
	visible = Input.is_action_pressed("aim");
	if (visible):
		var weapon: BaseWeapon = weapon_controller.get_active_weapon();
		target_position = weapon.get_current_impact();
		if (abs((target_position - get_global_mouse_position()).length()) < 60):
			target_position = get_global_mouse_position();
		global_position = global_position.lerp(target_position, 2.5 * delta);
		
	
