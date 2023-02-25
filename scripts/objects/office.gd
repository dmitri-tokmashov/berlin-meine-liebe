extends StaticBody;

var type = "take";

func take(player: KinematicBody):
	player.move = false;
	get_node("collision").disabled = true;
	get_node("animation").play("open");
	get_node("sound").play();
	var _title = get_parent().get_parent().get_node("title");
	var _subtitle = get_parent().get_parent().get_node("subtitle");
	yield(get_tree().create_timer(2), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("club/upstairs/office/slon"), "А ты кто такой?", 3);
	yield(get_tree().create_timer(3), "timeout");
	_title.say("Это ты — Слон?", 2.5);
	yield(get_tree().create_timer(2.5), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("club/upstairs/office/slon"), "Вообще-то все зовут меня зовут Большой Эл.", 4);
	yield(get_tree().create_timer(4), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("club/upstairs/office/slon"), "Но если ты знаешь и такую мою кличку, то я понимаю, зачем ты пришёл.", 5);
	yield(get_tree().create_timer(5), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("club/upstairs/office/slon"), "Ты один из кислотников, верно? Выглядишь как торчок, но чуть потрёпаннее.", 5.5);
	yield(get_tree().create_timer(5.5), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("club/upstairs/office/slon"), "Тут одному человечку нужен эскорт. Ну ты понимаешь, я не про сосание хуёв после попоек в жральнях.", 6);
	yield(get_tree().create_timer(6), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("club/upstairs/office/slon"), "Девочка очень напугана и просится на восточную сторону.", 4.5);
	yield(get_tree().create_timer(4.5), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("club/upstairs/office/slon"), "Ну я думаю, что ты разберёшься. Она в VIP чилауте, вот, возьми карту доступа.", 5.5);
	yield(get_tree().create_timer(5), "timeout");
	get_parent().get_parent().get_node("objects/card").visible = true;
	player.move = true;
