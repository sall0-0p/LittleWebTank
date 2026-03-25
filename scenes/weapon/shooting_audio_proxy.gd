extends Node2D

func play():
	var sounds = get_children();
	var specific = round(randf_range(0, sounds.size() - 1));
	sounds[specific].play();
