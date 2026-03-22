extends BaseWeaponComponent

func _on_weapon_fired():
	var ammo = weapon.ammo_type;
	var shell = ammo.shell_scene.instantiate();
	shell.position = global_position;
	shell.initial_velocity = ammo.muzzle_velocity;
	shell.initial_pitch = weapon.mantlet.elevation;
	shell.initial_altitude = weapon.trunnion_height;
	shell.explosion_scale = 1.5;
	shell.global_rotation = global_rotation - deg_to_rad(90);
	get_tree().root.add_child(shell);
