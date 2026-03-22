extends Sprite2D

const dust_scene = preload("res://scenes/cannon/cannon_dust.tscn");
const shell_scene = preload("res://scenes/shell/shell.tscn");

@export_category("Depression")
@export var depression_level: float = 5;
@export var depression_speed: float = 0.2;
@export var recovery_speed: float = 0.4;
@export var recovery_delay: float = 0.2;

@export_category("Dust")
@export var dust_scale: float = 1.0;

@export_category("Shell")
@export var explosion_scale: float = 2.0;
@export var shell_velocity: float = 120.0;


var default_position: Vector2 = Vector2.ZERO;
func _ready():
	default_position = position;
	
func depress():
	var tween = create_tween();
	tween.tween_property(self, "position:x", default_position.x - depression_level, depression_speed).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT);
	tween.tween_interval(recovery_delay);
	tween.tween_property(self, "position:x", default_position.x, recovery_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT);
	tween.play();
	
func spawn_dust():
	var dust = dust_scene.instantiate();
	dust.position = $DustPoint.position;
	add_child(dust);
	dust.scale = Vector2(dust_scale, dust_scale);
	
func fire_vfx():
	spawn_dust();
	depress();

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		# calculate firing angle
		var facing = Vector2.from_angle(global_rotation).rotated(deg_to_rad(-90));
		var length = (get_global_mouse_position() - global_position).length()
		var target_position = $Muzzle.global_position + (facing * length);
		
		# create shell and launch it
		var shell = shell_scene.instantiate();
		shell.position = $Muzzle.global_position
		shell.velocity = shell_velocity;
		shell.target_position = target_position;
		get_tree().root.add_child(shell);
		fire_vfx();
