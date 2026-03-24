extends CharacterBody2D
class_name BaseVehicle

@export var movement_controller: BaseMovementController;
@export var weapon_controller: WeaponController;
@export var vehicle_audio_controller: VehicleAudioController;

func _physics_process(delta: float) -> void:
	pass;
