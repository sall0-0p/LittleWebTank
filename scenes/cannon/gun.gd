extends Sprite2D

const dust_scene = preload("res://scenes/cannon/cannon_dust.tscn");
const shell_scene = preload("res://scenes/shell/shell.tscn");
const ART_SCALE_FACTOR = 15;
const GRAVITY = 9.81;

@export var trunnion_height: float = 2.1;

@export_category("Recoil")
@export var recoil_level: float = 5;
@export var recoil_speed: float = 0.2;
@export var recovery_speed: float = 0.4;
@export var recovery_delay: float = 0.2;

@export_category("Dust")
@export var dust_scale: float = 1.0;

@export_category("Elevation")
@export var traverse_speed: float = 5.0;
@export var max_elevation: float = 20.0;
@export var max_depression: float = -12.0;
@export var elevation: float = 0.0:
	get():
		return _elevation;
	set(value):
		pass;

@export_category("Shell")
@export var ammo_type: String = "76mm High Explosive";
@export var explosion_scale: float = 1.0;
@export var shell_velocity: float = 180.0;
@export var caliber: float = 76.2;
@export var drag_coefficient: float = 0.3;
@export var mass: float = 7.0;
@export var tolerance: float = 1;

var last_target_position = Vector2.ZERO;
var last_muzzle_position = Vector2.ZERO;
var default_position: Vector2 = Vector2.ZERO;
var target_elevation = 0.0;
var _elevation: float = 0.0;

# VFX
func _ready():
	default_position = position;
	
func _depress():
	var tween = create_tween();
	tween.tween_property(self, "position:x", default_position.x - recoil_level, recoil_speed).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT);
	tween.tween_interval(recovery_delay);
	tween.tween_property(self, "position:x", default_position.x, recovery_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT);
	tween.play();
	
func _spawn_dust():
	var dust = dust_scene.instantiate();
	dust.position = $DustPoint.position;
	add_child(dust);
	dust.scale = Vector2(dust_scale, dust_scale);
	
func fire_vfx():
	_spawn_dust();
	_depress();
	
# Logic
func predict_landing(test_angle_rad: float):
	var sim_v: float = shell_velocity * sin(test_angle_rad);
	var sim_h: float = shell_velocity * cos(test_angle_rad);
	var sim_altitude: float = trunnion_height;
	var sim_distance_travelled: float = 0;
	var step_delta: float = 0.016;
	var caliber_in_meters: float = caliber / 1000;
	var cross_section: float = PI * (caliber_in_meters/2.0)**2.0;
	
	while (sim_altitude > 0.0):
		var total_speed: float = sqrt(sim_v**2 + sim_h**2);
		var drag: float = 0.5 * 1.225 * (total_speed**2) * drag_coefficient * cross_section;
		var drag_decelleration: float = drag / mass;
		
		var ratio_h: float = 0;
		var ratio_v: float = 0;
		if (total_speed > 0):
			ratio_h = sim_h / total_speed;
			ratio_v = sim_v / total_speed;
		
		sim_h -= (drag_decelleration * ratio_h) * step_delta;
		sim_v -= (drag_decelleration * ratio_v + GRAVITY) * step_delta;
		
		sim_distance_travelled += sim_h * ART_SCALE_FACTOR * step_delta;
		sim_altitude += sim_v * step_delta;
		
		if sim_distance_travelled > 10000.0:
			break;
			
	return sim_distance_travelled;
	
func calculate_elevation(target_distance: float, accuracy: float):
	var min_angle = max_depression;
	var max_angle = max_elevation;
	
	var iteration_count = 0;
	var current_best = 0.0;
	while (iteration_count < 15):
		var midpoint = (min_angle + max_angle) / 2;
		var sim_distance = predict_landing(deg_to_rad(midpoint));
		
		if (abs(target_distance - sim_distance) < accuracy):
			return midpoint;
			
		if (sim_distance < target_distance):
			min_angle = midpoint;
		else:
			max_angle = midpoint;
			
		current_best = midpoint;
		iteration_count += 1;;
	return current_best;

func _physics_process(delta: float) -> void:
	# calculate firing angle
	var facing = Vector2.from_angle(global_rotation).rotated(deg_to_rad(-90));
	var distance = (get_global_mouse_position() - global_position).length()
	var target_position = $Muzzle.global_position + (facing * distance);
	var target_magnitude = abs((last_muzzle_position - target_position).length());
	var muzzle_magnitude = abs((last_muzzle_position - $Muzzle.global_position).length());
	
	if (target_magnitude > 1 or muzzle_magnitude > 1):
		target_elevation = calculate_elevation(distance, tolerance * ART_SCALE_FACTOR);
		last_target_position = target_position;
		last_muzzle_position = $Muzzle.global_position
	
	# adjust elevation
	var step = traverse_speed * delta;
	_elevation = clamp(move_toward(_elevation, target_elevation, step), max_depression, max_elevation);

# inputs
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		# create shell and launch it
		var shell = shell_scene.instantiate();
		shell.position = $Muzzle.global_position;
		shell.initial_velocity = shell_velocity;
		shell.initial_pitch = _elevation;
		shell.initial_altitude = 2.1;
		shell.explosion_scale = explosion_scale;
		shell.global_rotation = global_rotation - deg_to_rad(90);
		get_tree().root.add_child(shell);
		fire_vfx();
