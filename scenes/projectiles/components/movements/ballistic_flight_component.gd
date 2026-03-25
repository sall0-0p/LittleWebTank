extends BaseShellFlightComponent

const ART_SCALE_FACTOR := 15.0;
const GRAVITY = 9.81;

@export var main_sprite: Sprite2D;

var velocity_h: float;
var velocity_v: float;
var altitude: float;
var pitch: float;
var mass: float;
var drag_coefficient: float;
var cross_section: float;
var caliber: float;
var arming_distance: float;
var base_sprite_scale: Vector2 = Vector2.ONE;

var distance_travelled: float = 0;
func init(ammo: ProjectileData, pitch_degrees: float, alt: float):
	altitude = alt;
	pitch = deg_to_rad(pitch_degrees);
	caliber = ammo.caliber / 1000;
	
	mass = ammo.mass;
	drag_coefficient = ammo.drag_coefficient;
	arming_distance = ammo.arming_distance;
	
	var initial_velocity = ammo.muzzle_velocity;
	velocity_h = initial_velocity * cos(pitch);
	velocity_v = initial_velocity * sin(pitch);
	
	cross_section = PI * (caliber/2.0)**2.0;
	if (main_sprite):
		base_sprite_scale = main_sprite.scale;

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
	
	var current_position = get_parent().global_position;
	var facing = Vector2.from_angle(get_parent().global_rotation);
	
	var h_step = (facing * velocity_h * ART_SCALE_FACTOR * delta);
	var v_step = velocity_v * delta;
	
	var target_position = current_position + h_step;
	var target_altitude = altitude + v_step;
	
	# arming distance to prevent shell from exploding inside a barrel;
	distance_travelled += h_step.length();
	if (distance_travelled / ART_SCALE_FACTOR < arming_distance):
		main_sprite.visible = false
	else:
		main_sprite.visible = true;

	# collision detection
	var altitude_collision_at: float = 2.0;
	var raycast_collision_at: float = 2.0;
	if (target_altitude <= 0):
		altitude_collision_at = altitude / (altitude - target_altitude);
		
	# raycast
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state;
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(current_position, target_position);
	query.hit_from_inside = true;
	query.exclude = [get_parent().origin, get_parent()];
	var result = space_state.intersect_ray(query);
	if (result):
		raycast_collision_at = (current_position - result.position).length() / (current_position - target_position).length();
	
	var to_run;
	
	# determine which one to trigger:
	if (altitude_collision_at <= 1 and raycast_collision_at <= 1):
		if (altitude_collision_at < raycast_collision_at):
			to_run = "alt";
		else:
			to_run = "ray";
	elif (altitude_collision_at <= 1):
		to_run = "alt";
	elif (raycast_collision_at <= 1):
		to_run = "ray"
	
	# notify;
	if (to_run == "alt"):
		get_parent().global_position = current_position + (h_step * altitude_collision_at);
		altitude = altitude + (v_step * altitude_collision_at);
		
		# emit signal
		impact_detected.emit(null, get_parent().global_position, Vector2.ZERO, pitch, -1);
		return;
		
	if (to_run == "ray"):
		get_parent().global_position = result.position;
		altitude = altitude + (v_step * raycast_collision_at);
		
		# emit signal
		impact_detected.emit(result.collider, result.position, result.normal, pitch, result.shape);
		return;
		
	get_parent().current_velocity = total_speed;
	get_parent().global_position = target_position;
	altitude = target_altitude;

func _process(_delta: float) -> void:
	if (main_sprite):
		main_sprite.scale.y = base_sprite_scale.y * abs(1.0 - (abs(pitch)));
	
	
