extends Marker2D
class_name BaseWeaponComponent

@export var weapon: BaseWeapon;

func _ready() -> void:
	if (not weapon):
		weapon = get_parent();
	
	if (weapon.has_signal("weapon_fired")):
		weapon.weapon_fired.connect(_on_weapon_fired);

func _on_weapon_fired():
	pass;
