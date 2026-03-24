extends Node2D
class_name VehicleAudioController

@export_category("Engine")
@export var engine_pitch_min = 0.8;
@export var engine_pitch_max = 1.0;

var _throttle: float = 0.0;
func _ready():
	$EngineSound.play();
	$EngineSound.stream.loop = true;

func _process(delta: float) -> void:
	var pitch_difference = engine_pitch_max - engine_pitch_min;
	var target_pitch: float = 0.0;
	if (_throttle >= 0):
		target_pitch = engine_pitch_min + pitch_difference * _throttle;
	else:
		target_pitch = engine_pitch_min + pitch_difference * abs(_throttle / 2);
	$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, target_pitch, 0.1);

func set_throttle(throttle: float):
	_throttle = throttle;
	
