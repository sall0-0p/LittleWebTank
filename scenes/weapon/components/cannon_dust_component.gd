extends BaseWeaponComponent

func _on_weapon_fired():
	$Dust.visible = true;
	$Dust.play();

func _on_dust_animation_finished() -> void:
	$Dust.visible = false;
