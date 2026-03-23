extends Sprite2D

@export var shadow_offset: Vector2 = Vector2(-5, 5);
@export var color = Color8(0, 0, 0, 78);
		
func _ready():
	modulate = color;
	texture = get_parent().texture;
		

func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position + shadow_offset;
