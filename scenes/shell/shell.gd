extends Area2D

const ART_SCALE_FACTOR := 15.0;
const GRAVITY = 9.81;

@export_category("Initial properties")
@export var initial_velocity: float = 40;
@export var initial_altitude: float = 3.0;
@export var initial_pitch: float = 0.0;

@export_category("Shell")
@export var caliber_in_mm: float = 76.2;
@export var drag_coefficient: float = 0.3;
@export var mass: float = 7;

@export_category("Warhead")
@export var explosion_scale: float = 1.0;

var pitch: float;
var velocity_h: float;
var velocity_v: float;
var altitude: float;
var cross_section: float;
func _ready():

	var caliber_in_meters: float = caliber_in_mm / 1000;
	pitch = deg_to_rad(initial_pitch);
	velocity_h = initial_velocity * cos(pitch);
	velocity_v = initial_velocity * sin(pitch);

	altitude = initial_altitude;
	cross_section = PI * (caliber_in_meters/2.0)**2.0;

func _physics_process(delta: float) -> void:
	var total_speed: float = sqrt(velocity_v**2 + velocity_h**2);
	var drag: float = 0.5 * 1.225 * (total_speed**2) * drag_coefficient * cross_section;
	var drag_decelleration: float = drag / mass;
	
	var ratio_h: float = 0;
	var ratio_v: float = 0;
	if (total_speed > 0):
		ratio_h = velocity_h / total_speed;
		ratio_v = velocity_v / total_speed;
		
	velocity_h -= (drag_decelleration * ratio_h) * delta;
	velocity_v -= (drag_decelleration * ratio_v + GRAVITY) * delta;
	
	pitch = atan2(velocity_v, velocity_h);
	
	var facing = Vector2.from_angle(global_rotation);
	global_position += facing * velocity_h * ART_SCALE_FACTOR * delta;
	
	altitude += velocity_v * delta;
	
	if (altitude <= 0.0):
		$Warhead.explode(explosion_scale);
		queue_free();
		
func _process(_delta: float) -> void:
	$Sprite2D.scale.y = abs(1.0 - (abs(pitch)));
