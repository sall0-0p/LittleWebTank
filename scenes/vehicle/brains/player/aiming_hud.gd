extends Node2D

const ART_SCALE_FIX = 15;

@export var player_brain: Node2D;

func _process(_delta: float) -> void:
	visible = Input.is_action_pressed("aim");
	if (visible):
		if (player_brain and player_brain.get_controlled_unit()):
			var weapon_controller: WeaponController = player_brain.get_controlled_unit().weapon_controller;
			var weapon: BaseWeapon = weapon_controller.get_active_weapon();
			var weapon_pos: Vector2 = weapon.global_position;
			var target_pos: Vector2 = get_global_mouse_position();
			
			var distance: float = abs((weapon_pos - target_pos).length());
			var elevation: float = weapon.mantlet.elevation;
			var ammo = weapon.ammo_type.name;
			
			$Label.text = "%s\n%s°\n%sm" % [ammo, snapped(elevation, 0.1), round(distance / ART_SCALE_FIX)]
			
			global_position = target_pos + Vector2(20, 20);
			global_rotation = 0;
	
	
