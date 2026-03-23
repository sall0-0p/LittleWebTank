extends Node2D

const explosion_scene = preload("res://scenes/projectile/explosion/he_explosion.tscn");

func explode(explosion_scale):
	var explosion = explosion_scene.instantiate();
	explosion.global_position = global_position;
	explosion.explosion_scale = explosion_scale;
	get_tree().root.add_child(explosion);
