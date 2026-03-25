extends Sprite2D

@export var player_brain: Node2D;

var target_position = Vector2.ZERO;
var reloading_texture: Texture = preload("res://assets/hud/segmented-indicator.png");
var targeting_texture: Texture = preload("res://assets/hud/reticle-outer.png");
func _process(delta: float) -> void:
	visible = Input.is_action_pressed("aim");
	if (visible):
		if (player_brain and player_brain.controlled_unit):
			var weapon_controller: WeaponController = player_brain.controlled_unit.weapon_controller;
			var weapon: BaseWeapon = weapon_controller.get_active_weapon();
			
			# adjust gun position;
			target_position = weapon.get_current_impact();
			if (abs((target_position - get_global_mouse_position()).length()) < 60):
				target_position = get_global_mouse_position();
			global_position = global_position.lerp(target_position, 2.5 * delta);
			
			# change sprite if reloading
			if (weapon.is_reloading()):
				texture = reloading_texture;
				region_enabled = true;
				
				var ammo_type: ProjectileData = weapon.ammo_type;
				var time_left = weapon.get_reloading_time_left();
				var progress = 0.0;
				
				if (time_left > 0):
					progress = 1 - weapon.get_reloading_time_left() / ammo_type.base_reload_time;
				
				var current_reload = clamp(snapped(progress * texture.get_width(), 64), 0, texture.get_width() - 64);
				scale = Vector2(0.7, 0.7);
				region_rect = Rect2(current_reload, 0, 64, 64);
			else:
				texture = targeting_texture;
				scale = Vector2(1, 1);
				region_enabled = false;
				region_rect = Rect2(0, 0, 64, 64);
