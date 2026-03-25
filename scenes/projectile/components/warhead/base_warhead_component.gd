extends BaseShellComponent
class_name BaseWarheadComponent

const explosion_scene = preload("res://scenes/projectile/explosion/he_explosion.tscn");

var ammo_type: ProjectileData;
func init(ammo: ProjectileData):
	ammo_type = ammo;
	
func detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float, current_velocity: Vector3, shape_index: int):
	get_parent().queue_free();
