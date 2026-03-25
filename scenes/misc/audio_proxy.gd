extends Node2D
class_name SoundProxy
signal finished;

@export var randomise_pitch: bool = false;

var current_sound: AudioStreamPlayer2D;
func play():
	var sounds = get_children();
	var specific = round(randf_range(0, sounds.size() - 1));
	var sound: AudioStreamPlayer2D = sounds[specific];
	if (randomise_pitch):
		sound.pitch_scale = randf_range(0.8, 1.2);
	
	current_sound = sound;
	sound.play();
	sound.finished.connect(_finished_callback);

func _finished_callback():
	if (current_sound):
		current_sound.finished.disconnect(_finished_callback);
		current_sound = null;
	finished.emit();
