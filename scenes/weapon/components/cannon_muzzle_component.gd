extends BaseWeaponComponent

func _on_weapon_fired():
	var ammo = weapon.ammo_type;
	var shell = ammo.shell_scene.instantiate();

	shell.global_position = global_position;
	
	var base_angle = global_rotation - deg_to_rad(90);
	var max_spread = weapon.base_spread_degrees * ammo.spread_multiplier;
	var spread = deg_to_rad(randf_range(-max_spread, +max_spread));
	shell.global_rotation = base_angle + spread;
	
	shell.setup(ammo, weapon.mantlet.elevation, weapon.trunnion_height, get_parent());
	get_tree().root.add_child(shell);
