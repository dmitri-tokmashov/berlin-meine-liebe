extends Spatial;

var type: String = "take";

func take(player: KinematicBody):
	get_node("sound").play();
	get_node("collision").disabled = true;
	get_parent().get_parent().objects.chief.active = false;
	player.move = false;
	yield(get_tree().create_timer(1), "timeout");
	get_parent().get_parent().objects.chief.talk(player);

func use(player):
	player.object.drop();
