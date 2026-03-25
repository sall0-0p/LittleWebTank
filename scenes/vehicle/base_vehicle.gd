extends CharacterBody2D
class_name BaseVehicle

@export var movement_controller: BaseMovementController;
@export var weapon_controller: WeaponController;
@export var vehicle_audio_controller: VehicleAudioController;

var _children_cache: Array[Node];

func _physics_process(delta: float) -> void:
	pass;

func get_rid_of_all_physical_children() -> Array[RID]:
	var array: Array[RID] = [];
	var children = get_all_children();
	for child in children:
		if (child.has_method("get_rid")):
			array.append(child.get_rid());
	
	return array;
	
func get_all_children() -> Array[Node]:
	if (_children_cache):
		return _children_cache;
	
	_children_cache = _get_all_children_of_node(self);
	return _children_cache;

func _get_all_children_of_node(node: Node) -> Array[Node]:
	var array: Array[Node] = [ node ]
	for child in node.get_children():
		var children_rids = _get_all_children_of_node(child);
		array.append_array(children_rids);
	
	return array;
