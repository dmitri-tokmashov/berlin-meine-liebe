extends StaticBody

var type: String = "take";

func _ready():
	pass # Replace with function body.

func take(player):
	get_node("collision").disabled = true;
	get_node("animation").play("open");
	yield(get_tree().create_timer(2), "timeout");
	get_parent().get_parent().get_node("objects/phone/sound").play();
