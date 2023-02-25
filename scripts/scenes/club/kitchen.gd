extends Spatial

onready var chief = get_node("chief");

func _ready():
	chief.get_node("AnimationPlayer").get_animation("default").loop = true;
	chief.get_node("AnimationPlayer").play("default");
	hide();

func hide():
	for node in ["cabinet_1", "cabinet_2", "cabinet_3", "chief", "fridge_1", "fridge_2", "sink", "stove"]:
		get_node(node).visible = false;
	get_node("light_1").omni_range = 3;
	get_node("light_1").shadow_enabled = false;

func show():
	for node in ["cabinet_1", "cabinet_2", "cabinet_3", "chief", "fridge_1", "fridge_2", "sink", "stove"]:
		get_node(node).visible = true;
	get_node("light_1").omni_range = 4.8;
	get_node("light_1").shadow_enabled = true;
