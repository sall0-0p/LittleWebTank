extends Node2D
class_name VehicleAudioController

@export_category("Engine")
@export var engine_pitch_min = 0.8;
@export var engine_pitch_max = 1.0;

var _throttle: float = 0.0;
var _steering: float = 0.0;
func _ready():
	$EngineSound.play();

func _process(_delta: float) -> void:
	_process_engine();

func _process_engine():
	var pitch_difference = engine_pitch_max - engine_pitch_min;
	var target_pitch: float = 0.0;
	if (_throttle >= 0):
		target_pitch = engine_pitch_min + pitch_difference * _throttle;
	else:
		target_pitch = engine_pitch_min + pitch_difference * abs(_throttle / 2);
	$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, target_pitch, 0.1);

func _process_tracks():
	if (_throttle != 0 or _steering != 0):
		$TrackSound.playing = true;
	else:
		$TrackSound.playing = false;

func set_throttle(throttle: float):
	_throttle = throttle;

func set_steering(steering: float):
	_steering = steering;
