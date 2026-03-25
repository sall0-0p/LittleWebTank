extends Area2D
class_name ArmorPlate

@export var thickness: float = 0.0;
@export var angle: float = 0.0;
@export var density: float = 0.0;
@export var direction: Vector2 = Vector2.RIGHT;
@export var lowest_position: float = 1;
@export var highest_position: float = 1.75;

func get_unit():
	var ancestors = get_node_ancestors(self);
	for ancestor in ancestors:
		if ancestor is BaseVehicle:
			return ancestor;
	return null;
	
func get_node_ancestors(node: Node) -> Array[Node]:
	var result: Array[Node] = [ node ];
	if (node.get_parent()):
		result.append_array(get_node_ancestors(node.get_parent()));
	return result;
