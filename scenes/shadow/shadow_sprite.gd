extends Sprite2D

@export var shadow_offset: Vector2 = Vector2(-5, 5);
@export var original: Sprite2D:
	set(value):
		texture = value.texture;

@export var color = Color8(0, 0, 0, 78):
	set(value):
		modulate = value;
		
func _ready():
	modulate = color;

func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position + shadow_offset;
