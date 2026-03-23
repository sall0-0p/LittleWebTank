extends BaseShellComponent
class_name BaseFuzeComponent
signal detonate(hit_object: Object, impact_point: Vector2, impact_normal: Vector2, pitch: float)

@export var flight_component: BaseShellFlightComponent;

func _ready() -> void:
	if (flight_component):
		flight_component.impact_detected.connect(_on_shell_impact);
	else:
		push_warning("No flight_component detected for a fuze. Shells will not detonate.");
	
func init(ammo_type: ProjectileData):
	pass;

func _on_shell_impact(hit_object: Node2D, impact_point: Vector2, impact_normal: Vector2, pitch: float):
	pass;
