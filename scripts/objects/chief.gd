extends StaticBody;

var active: bool = true;
var type: String = "talk";
var state: int = 0;

func talk(player):
	active = false;
	player.move = false;
	get_parent().get_parent().objects.door.get_node("collision").disabled = true;
	var _title = get_parent().get_parent().get_node("title");
	var _subtitle = get_parent().get_parent().get_node("subtitle");
	if state == 0:
		_subtitle.say(self, "Что-то ищешь тут, чувак?", 2.5);
		yield(get_tree().create_timer(2.5), "timeout");
		_title.say("Да в клуб нужно, жесть просто, а на входе стрёмные типы на негативе. Здесь же можно пройти?", 4);
		yield(get_tree().create_timer(4), "timeout");
		_subtitle.say(self, "Не… Тут вход только для персонала.", 2.5);
		yield(get_tree().create_timer(2.5), "timeout");
		_title.say("О, ты в клубе работаешь? Чем там занимаешься?", 2.5);
		yield(get_tree().create_timer(2.5), "timeout");
		_subtitle.say(self, "Моя профессия… Повар.", 2);
		yield(get_tree().create_timer(2), "timeout");
		_subtitle.say(self, "Знаешь… Есть одна тема…", 2.5);
		yield(get_tree().create_timer(2.5), "timeout");
		_subtitle.say(self, "Мне тут бадягу подогнали, типа кристаллов.", 3.25);
		yield(get_tree().create_timer(3.25), "timeout");
		_subtitle.say(self, "Сказали, что вещица адская — какая-то новая синтетика из Америки.", 4);
		yield(get_tree().create_timer(4), "timeout");
		_subtitle.say(self, "Ну знаешь, в Майами варят лучшие продукты!", 3.25);
		yield(get_tree().create_timer(3.25), "timeout");
		_subtitle.say(self, "Так вот: одному мне её курить ссыкотно. А ты, чувак, извини, но ты выглядишь, как лютый кислотник.", 7.5);
		yield(get_tree().create_timer(7.5), "timeout");
		_subtitle.say(self, "Короче, давай эту бадягу хапнем сейчас на двоих?", 3.5);
		yield(get_tree().create_timer(3.5), "timeout");
		_subtitle.say(self, "Поделюсь с тобой за так, потом сможешь зайти в клуб через кухню, если не откиснем.", 7);
		yield(get_tree().create_timer(7), "timeout");
		_subtitle.say(self, "Только найди бутылку какую-нибудь, я пока тут подожду, пораскуриваюсь, за кухней присмотрю.", 7);
		yield(get_tree().create_timer(7), "timeout");
		_subtitle.say(self, "А то, знаешь, бродят тут наркоманы всякие.", 3.25);
		yield(get_tree().create_timer(3.25), "timeout");
		state = 1;
		player.move = true;
		get_parent().get_parent().objects.door.get_node("collision").disabled = false;
		_title.say("Лады, намучу сейчас бутылочку.", 3);
		yield(get_tree().create_timer(6), "timeout");
	else:
		_subtitle.say(self, ["Чувак, не тупи, ищи бутылку!", "Сначала покурим, потом пущу."][randi() % 2], 2.5);
		yield(get_tree().create_timer(2.5), "timeout");
		player.move = true;
		get_parent().get_parent().objects.door.get_node("collision").disabled = false;
	active = true;

func use(player):
	active = false;
	player.move = false;
	get_parent().get_parent().objects.door.get_node("collision").disabled = true;
	var _title = get_parent().get_parent().get_node("title");
	var _subtitle = get_parent().get_parent().get_node("subtitle");
	if player.object == get_parent().get_parent().objects.bottle:
		player.object.queue_free();
		player.object = null;
		if state == 0:
			_subtitle.say(self, "Чувак, ну ты волшебник, это то, что нужно!", 3.25);
			yield(get_tree().create_timer(3.25), "timeout");
			_title.say("Собираешь пустые бутылки?", 2.5);
			yield(get_tree().create_timer(2.5), "timeout");
			_subtitle.say(self, "Типа того, чувак… Не интересует тема одна?", 3);
			yield(get_tree().create_timer(3), "timeout");
			_subtitle.say(self, "Мне тут бадягу подогнали, типа кристаллов.", 3.25);
			yield(get_tree().create_timer(3.25), "timeout");
			_subtitle.say(self, "Сказали, что вещица адская — какая-то новая синтетика из Америки.", 4);
			yield(get_tree().create_timer(4), "timeout");
			_subtitle.say(self, "Ну знаешь, в Майами варят лучшие продукты!", 3.25);
			yield(get_tree().create_timer(3.25), "timeout");
			_subtitle.say(self, "Так вот: одному мне её курить ссыкотно. А ты, чувак, извини, но ты выглядишь, как лютый кислотник.", 7.5);
			yield(get_tree().create_timer(7.5), "timeout");
			_subtitle.say(self, "Короче, давай эту бадягу хапнем сейчас на двоих?", 3.5);
			yield(get_tree().create_timer(3.5), "timeout");
			_title.say("Курить непонятную дичь с непонятным типом? Какая-то мутная тема…", 4);
			yield(get_tree().create_timer(4), "timeout");
			_subtitle.say(self, "Чувак, да я нормальный мужик, работаю здесь, в клубе. Хочешь, проведу внутрь, как курнём?", 6);
			yield(get_tree().create_timer(6), "timeout");
			_title.say("Хм… Ладно, похуй, доставай!", 3);
			yield(get_tree().create_timer(3), "timeout");
			_subtitle.say(self, "О, заебись! Ну что, начнём делать магию…", 3.25);
			yield(get_tree().create_timer(3.25), "timeout");
		elif state == 1:
			_subtitle.say(self, "О, принёс! Ну что, начнём делать магию…", 3.25);
			yield(get_tree().create_timer(3.25), "timeout");
		state = 2;
		var tween = get_tree().create_tween();
		tween.tween_property(get_parent().get_parent().get_node("curtain"), "color", Color(0, 0, 0, 1), 2);
		yield(get_tree().create_timer(2), "timeout");

		get_parent().get_parent().state = 1;
		player.translation = Vector3(29, 0, -7);
		get_parent().get_parent().get_node("street").visible = false;
		get_parent().get_parent().get_node("club/upstairs/logo/light_1").visible = false;
		get_parent().get_parent().get_node("club/upstairs/logo/light_2").visible = false;
		get_parent().get_parent().get_node("club/upstairs/logo/light_3").visible = false;
		get_parent().get_parent().get_node("club/upstairs/logo/light_4").visible = false;
		
		get_parent().get_parent().get_node("club/light_1").visible = true;
		get_parent().get_parent().get_node("club/light_2").visible = true;
		#get_parent().get_parent().get_node("club/light_3").visible = true;
		get_parent().get_parent().get_node("club/kitchen").show();

		tween = get_tree().create_tween();
		tween.tween_property(get_parent().get_parent().get_node("curtain"), "color", Color(0, 0, 0, 0), 2);
		yield(get_tree().create_timer(2), "timeout");
		player.move = true;
		_subtitle.say(get_parent().get_parent().get_node("club/kitchen/chief"), "Вух! Ништяк дунули! А сейчас я им таких фрактальных сосисок нажарю…", 3.75);
		yield(get_tree().create_timer(3.75), "timeout");
		_title.say("А, по-моему, это — полная хуйня, просроченный кефир выносит жёстче.", 3.5);
		yield(get_tree().create_timer(3.5), "timeout");
		_title.say("Но всё равно спасибо!", 2.5);
		queue_free();
