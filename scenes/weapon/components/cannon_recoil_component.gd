extends BaseWeaponComponent

@export var recoil_level: float = 5.0;
@export var recoil_speed: float = 0.2;
@export var recovery_speed: float = 0.4;
@export var recovery_delay: float = 0.2;
	
var default_position;
func _ready():
	super._ready();
	default_position = get_parent().position;
	
func _on_weapon_fired():
	var tween = create_tween();
	print(default_position);
	tween.tween_property(get_parent(), "position:x", default_position.x - recoil_level, recoil_speed).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT);
	tween.tween_interval(recovery_delay);
	tween.tween_property(get_parent(), "position:x", default_position.x, recovery_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT);
	tween.play();
