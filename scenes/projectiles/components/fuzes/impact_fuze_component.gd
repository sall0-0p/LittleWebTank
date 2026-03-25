extends BaseFuzeComponent

const VELOCITY_SCALE_FACTOR = 5.0;

@export var detonate_on_impact = false;
@export var detonate_when_destroyed = false;
@export var minimum_penetration = 15.0;
@export var fuze_delay = 0.0;

var last_properties = [];
func trigger(hit_object: Node2D, impact_point: Vector2, impact_normal: Vector2, impact_velocity: Vector3, pitch: float, shape_index: int) -> Dictionary:
	if (not hit_object or not (hit_object is ArmorPlate)):
		detonate.emit(hit_object, impact_point, impact_normal, pitch, shape_index);
		return {};
	
	# calculate effective thickness
	var armor: ArmorPlate = hit_object;
	var angle = deg_to_rad(armor.angle);
	var shell_direction = impact_velocity.normalized();
	var armor_normal: Vector3 = Vector3(impact_normal.x * cos(angle), sin(angle), impact_normal.y * cos(angle));
	var impact_dot = (-shell_direction).dot(armor_normal);
	var effective_thickness = armor.thickness / impact_dot;
	
	if (impact_dot < 0.35):
		var ricochet_vector = impact_velocity - 2 * (impact_velocity * armor_normal) * armor_normal;
		ricochet_vector *= 0.6;
		return {
			"penetrate": false,
			"ricochet": true,
			"ricochet_vector": ricochet_vector,
		}
	
	if (detonate_on_impact):
		detonate.emit(hit_object, impact_point, impact_normal, pitch, shape_index);
		return {};
	
	var impact_speed = sqrt(impact_velocity.x**2 + impact_velocity.y**2 + impact_velocity.z**2);
	var k = (ammo_type.mass**0.5 * ammo_type.muzzle_velocity * VELOCITY_SCALE_FACTOR) / (ammo_type.base_penetration**0.7 * ammo_type.caliber**0.75);
	var penetration = ((ammo_type.mass**0.5 * impact_speed * VELOCITY_SCALE_FACTOR) / (k * ammo_type.caliber**0.75))**1.428;
	
	prints(effective_thickness, penetration);
	if (penetration > effective_thickness):
		if (effective_thickness > minimum_penetration):
			if (fuze_delay > 0.0):
				last_properties = [ hit_object, impact_point, impact_normal, pitch, shape_index ];
				$FuzeDelay.wait_time = fuze_delay;
				$FuzeDelay.start();
			else:
				detonate.emit(hit_object, impact_point, impact_normal, pitch, shape_index);
			
		return {
			"penetrate": true,
			"effective_thickness": effective_thickness,
			"current_penetration": penetration,
		}
	else:
		detonate.emit(hit_object, impact_point, impact_normal, pitch, shape_index);
		return {
			"penetrate": false,
		}

func _on_fuze_delay_timeout() -> void:
	detonate.emit(last_properties[0], last_properties[1], last_properties[2], last_properties[3], last_properties[4]);
