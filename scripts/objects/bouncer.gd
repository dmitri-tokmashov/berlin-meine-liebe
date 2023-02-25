extends StaticBody;

var active: bool = true;
var type: String = "talk";
var state: int = 0;

func talk(player):
	active = false;
	player.move = false;
	var _title = get_parent().get_parent().get_node("title");
	var _subtitle = get_parent().get_parent().get_node("subtitle");
	if get_parent().get_parent().state < 1:
		if state == 0:
			_subtitle.say(self, "Клуб полный, становись в очередь и жди, когда освободится место.", 3);
			yield(get_tree().create_timer(3), "timeout");
			state = 1;
		elif state == 1:
			_subtitle.say(self, "Ты глухой? Сказал же, сейчас не войдёшь!", 2.5);
			yield(get_tree().create_timer(2.5), "timeout");
			state = 2;
		elif state == 2:
			_subtitle.say(self, "В очередь, мужик!", 1.5);
			yield(get_tree().create_timer(1.5), "timeout");
	else:
		_subtitle.say(self, "Ты как туда пробрался?", 2);
		yield(get_tree().create_timer(2), "timeout");
	player.move = true;
	active = true;

func use(player):
	active = false;
	player.move = false;
	get_parent().get_parent().objects.door.get_node("collision").disabled = true;
	var _title = get_parent().get_parent().get_node("title");
	var _subtitle = get_parent().get_parent().get_node("subtitle");
	_subtitle.say(self, "Отвали со своим мусором!", 2);
	yield(get_tree().create_timer(2), "timeout");
	player.move = true;
	active = true;
