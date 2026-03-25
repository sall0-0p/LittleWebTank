extends Area2D
class_name BaseShell

@export var fuze_component: BaseFuzeComponent;
@export var warhead_component: BaseWarheadComponent;
@export var flight_component: BaseShellFlightComponent;
@export var current_velocity: Vector3 = Vector3.ZERO;
@export var origin: BaseVehicle;

var parent: BaseWeapon;
func setup(ammo_type: ProjectileData, pitch: float, altitude: float, gun: BaseWeapon) -> void:
	$Sprite2D.visible = false;
	if flight_component:
		flight_component.init(ammo_type, pitch, altitude);
		
	if warhead_component:
		warhead_component.init(ammo_type);
	
	if fuze_component:
		fuze_component.init(ammo_type);
	
	parent = gun;

func _ready() -> void:
	if fuze_component:
		fuze_component.detonate.connect(_on_detonate);

func _on_detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float, shape_index: int):
	$ExplosionSoundProxy.play();
	if flight_component:
		flight_component.queue_free();
	
	if warhead_component:
		warhead_component.detonate(hit_object, impact_point, impact_normal, pitch, current_velocity, shape_index);
		
	$Sprite2D.hide();
	await $ExplosionSoundProxy.finished;
	queue_free();
	
