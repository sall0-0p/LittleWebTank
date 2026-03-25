extends BaseShellComponent
class_name BaseFuzeComponent
signal detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float, shape_index: int)

var ammo_type: ProjectileData;
func init(ammo: ProjectileData):
	ammo_type = ammo;

# return true if continue flying, returns false if not;
func trigger(hit_object: Node2D, impact_point: Vector2, impact_normal: Vector2, current_velocity: Vector3, pitch: float, shape_index: int) -> Dictionary:
	return {
		"penetrate": false,
	};
	
