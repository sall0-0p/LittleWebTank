extends BaseWarheadComponent

@export var main_sprite: Sprite2D;
@export var particles: CPUParticles2D;

func detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float, current_velocity: float, shape_index: int):
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
	get_parent().queue_free();
