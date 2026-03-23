extends BaseWeaponComponent

func _on_weapon_fired():
	var ammo = weapon.ammo_type;
	var shell = ammo.shell_scene.instantiate();

	shell.global_position = global_position;
	shell.global_rotation = global_rotation - deg_to_rad(90);
	
	shell.setup(ammo, weapon.mantlet.elevation, weapon.trunnion_height);
	get_tree().root.add_child(shell);
