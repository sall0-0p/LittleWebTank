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

var invisible_for: int = 0;
var distance_travelled: float = 0;
var penetrated_rids: Array[RID] = [];
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
	
	var origin: BaseVehicle = get_parent().origin;
	penetrated_rids = origin.get_rid_of_all_physical_children();
	
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
	if (distance_travelled / ART_SCALE_FACTOR < arming_distance or invisible_for > 0):
		main_sprite.visible = false;
		invisible_for = max(0, invisible_for - 1);
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
	query.collide_with_areas = true;
	query.collide_with_bodies = true;
	query.exclude = penetrated_rids;
	query.collision_mask = 1 + (1 << 3) + (1 << 4);
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
	var shell_velocity = Vector3(facing.x * velocity_h, velocity_v, facing.y * velocity_h);
	var fuze: BaseFuzeComponent = get_parent().fuze_component;
	if (to_run == "alt"):
		get_parent().global_position = current_position + (h_step * altitude_collision_at);
		altitude = altitude + (v_step * altitude_collision_at);
		
		fuze.trigger(null, get_parent().global_position, Vector2.ZERO, shell_velocity, pitch, -1);
		return;
		
	if (to_run == "ray"):
		get_parent().global_position = result.position;
		altitude = altitude + (v_step * raycast_collision_at);
		
		#var go_on = fuze.trigger(result.collider, result.position, result.normal, pitch, result.shape);
		var hit_data = fuze.trigger(result.collider, result.position, result.normal, shell_velocity, pitch, result.shape);
		if hit_data and hit_data.get("penetrate", false):
			if result.collider is CollisionObject2D:
				penetrated_rids.append(result.collider.get_rid());
				
				var effective_thickness = hit_data.get("effective_thickness", 1.0);
				var current_penetration = hit_data.get("current_penetration", effective_thickness + 1.0);
				
				var retention_factor = sqrt(max(0.01, 1.0 - pow(effective_thickness / current_penetration, 2)));
				velocity_h *= retention_factor;
				velocity_v *= retention_factor;
			else:
				return;
		elif hit_data and hit_data.get("ricochet", false):
			var ricochet_vector = hit_data.get("ricochet_vector", shell_velocity * PI);
			
			main_sprite.visible = false;
			invisible_for = 2;
			velocity_v = ricochet_vector.y;
			velocity_h = Vector2(ricochet_vector.x, ricochet_vector.z).length();
			
			get_parent().global_rotation = atan2(ricochet_vector.z, ricochet_vector.x);
			
			if result.collider is Area2D:
				penetrated_rids.append(result.collider.get_rid());
				
				if (result.collider is ArmorPlate):
					var armor: ArmorPlate = result.collider;
					var unit: BaseVehicle = armor.get_unit();
					if (unit):
						penetrated_rids.append_array(unit.get_rid_of_all_physical_children());
			
			var remaining_delta_ratio = 1.0 - raycast_collision_at;
			var new_facing = Vector2.from_angle(get_parent().global_rotation);
			var remaining_h_step = new_facing * velocity_h * ART_SCALE_FACTOR * (delta * remaining_delta_ratio);
			var remaining_v_step = velocity_v * (delta * remaining_delta_ratio);
			
			get_parent().global_position += remaining_h_step;
			altitude += remaining_v_step;
			get_parent().current_velocity = ricochet_vector;
			
			return;
		
	get_parent().current_velocity = shell_velocity;
	get_parent().global_position = target_position;
	altitude = target_altitude;

func _process(_delta: float) -> void:
	if (main_sprite):
		main_sprite.scale.y = base_sprite_scale.y * abs(1.0 - (abs(pitch)));
	
	
