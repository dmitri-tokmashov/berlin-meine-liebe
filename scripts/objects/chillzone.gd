extends StaticBody;

var type = "take";

func take(player: KinematicBody):
	get_node("collision").disabled = true;
	get_parent().get_parent().get_node("objects/lock").take(player);
	#var _title = get_parent().get_parent().get_node("title");
	#var _subtitle = get_parent().get_parent().get_node("subtitle");
	#_title.say("Тут нужна ключ-карта.", 2.5);
	yield(get_tree().create_timer(2.5), "timeout");
	get_node("collision").disabled = false;

func use(player: KinematicBody):
	player.move = false;
	if player.object == get_parent().get_parent().objects.card:
		get_parent().get_parent().get_node("street").visible = true;
		get_node("collision").disabled = true;
		get_parent().get_parent().objects.lock.get_node("collision").disabled = true;
		get_parent().get_parent().objects.lock.get_node("audio").play();
		get_node("animation").play("open");
		get_node("sound").play();
		player.object.queue_free();
		player.object = null;
		get_parent().get_parent().meeting();
