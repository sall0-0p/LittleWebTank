extends BaseWeaponSolver

const ART_SCALE_FACTOR = 15;
const GRAVITY = 9.81;

func predict_impact_distance(elevation: float) -> float:
	var ammo_type = get_parent().ammo_type;
	var sim_v: float = ammo_type.muzzle_velocity * sin(elevation);
	var sim_h: float = ammo_type.muzzle_velocity * cos(elevation);
	var sim_altitude: float = get_parent().trunnion_height;
	var sim_distance_travelled: float = 0;
	var step_delta: float = 0.016;
	var caliber_in_meters: float = ammo_type.caliber / 1000;
	var cross_section: float = PI * (caliber_in_meters/2.0)**2.0;
	
	while (sim_altitude > 0.0):
		var total_speed: float = sqrt(sim_v**2 + sim_h**2);
		var drag: float = 0.5 * 1.225 * (total_speed**2) * ammo_type.drag_coefficient * cross_section;
		var drag_decelleration: float = drag / ammo_type.mass;
		
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
	
func calculate_elevation(distance: float, accuracy: float) -> float:
	var ammo_type = get_parent().ammo_type;
	var min_angle = get_parent().mantlet.max_depression;
	var max_angle = get_parent().mantlet.max_elevation;
	
	var iteration_count = 0;
	var current_best = 0.0;
	while (iteration_count < 15):
		var midpoint = (min_angle + max_angle) / 2;
		var sim_distance = predict_impact_distance(deg_to_rad(midpoint));
		
		if (abs(distance - sim_distance) < accuracy):
			return midpoint;
			
		if (sim_distance < distance):
			min_angle = midpoint;
		else:
			max_angle = midpoint;
			
		current_best = midpoint;
		iteration_count += 1;;
	return current_best;
