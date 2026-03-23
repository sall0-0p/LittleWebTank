extends BaseShellComponent
class_name BaseWarheadComponent

const explosion_scene = preload("res://scenes/projectile/explosion/he_explosion.tscn");

func init(ammo_type: ProjectileData):
	pass;
	
func detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float, current_velocity: Vector2):
	var explosion = explosion_scene.instantiate();
	explosion.global_position = impact_point;
	get_tree().root.add_child(explosion);
	get_parent().queue_free();
