extends Sprite2D

@export var shadow_offset: Vector2 = Vector2(-5, 5);
@export var color = Color8(0, 0, 0, 78);
@export var active: bool = true;
@export var target: Sprite2D;
		
func _ready():
	if (not target):
		show_behind_parent = true;
		z_index = 0;
		target = get_parent();
	
	modulate = color;
	texture = target.texture;
	if (target.region_enabled):
		region_enabled = true;
		region_rect = target.region_rect;
	scale = target.scale;
	global_rotation = target.global_rotation;

func _physics_process(_delta: float) -> void:
	global_position = get_parent().global_position + shadow_offset;
