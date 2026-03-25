extends BaseWarheadComponent

@export var particles: CPUParticles2D;
@export var main_sprite: Sprite2D;

func detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float, current_velocity: float, shape_index: int):
	var explosion = explosion_scene.instantiate();
	explosion.global_position = impact_point;
	explosion.explosion_scale = ammo_type.warhead_effect_multiplier;

	if (hit_object and shape_index != -1 and hit_object is BaseBuilding):
		hit_object.handle_hit(shape_index);
	
	get_tree().root.add_child(explosion);
	_spawn_fragmentation(impact_normal);

func _spawn_fragmentation(impact_normal):
	var warhead_multiplier = ammo_type.warhead_effect_multiplier;
	
	main_sprite.visible = false;
	particles.amount *= warhead_multiplier;
	particles.lifetime *= warhead_multiplier;
	particles.damping_max *= warhead_multiplier;
	particles.damping_min *= warhead_multiplier;
	particles.anim_speed_min *= warhead_multiplier;
	particles.anim_speed_max *= warhead_multiplier;
	
	if impact_normal == Vector2.ZERO or impact_normal == Vector2.ONE:
		particles.direction = Vector2.RIGHT;
		particles.spread = 180.0;
	else:
		particles.amount = particles.amount / 2;
		particles.direction = impact_normal;
		particles.spread = 75.0;
	
	particles.emitting = true;
	await get_tree().create_timer(particles.lifetime).timeout;
	return;
