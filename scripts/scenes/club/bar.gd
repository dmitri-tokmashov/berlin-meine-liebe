extends Node;

onready var bartenders = [get_node("bartender/model")];

func _ready():
	character.initialize("woman_0", "bartending", bartenders[0]);
	#bartenders[0].get_node("AnimationPlayer").get_animation("default").loop = true;
	#bartenders[0].get_node("AnimationPlayer").play("default");
	#bartenders[0].get_node("Skeleton/Belt_Plano019").visible = false;
	#bartenders[0].get_node("Skeleton/FinalShirt_Plano013").get_active_material(0).albedo_color = Color8(240, 32, 96);
