extends RigidBody;

var talking: bool = false;
var taken: bool = false;
var type: String = "take";

func _physics_process(delta):
	#if not sleeping:
		if taken:
			global_translation += (get_parent().to_global(Vector3(0.1, 0.7, -0.05)) - global_translation) * 4 * delta;
			global_rotation += (get_parent().global_rotation + Vector3(deg2rad(30), 0, 0) - global_rotation) * 4 * delta;

func take(player: KinematicBody):
	talking = true;
	get_node("sound").stop();
	get_node("collision").disabled = true;
	taken = true;
	var _position = global_translation;
	var _rotation = global_rotation;
	get_parent().remove_child(self);
	player.add_child(self);
	player.object = self;
	global_translation = _position;
	global_rotation = _rotation;

	yield(get_tree().create_timer(1), "timeout");
	var _title = get_parent().get_parent().get_node("title");
	var _subtitle = get_parent().get_parent().get_node("subtitle");
	_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "Не подскажите, как лучше добраться до Гамбурга?", 4);
	get_node("dialog_1").play();
	yield(get_tree().create_timer(4), "timeout");
	_title.say("Поездом, конечно! Советую взять вам экспресс через Дюссельдорф.", 4);
	yield(get_tree().create_timer(4), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "Господи, ну и бред… Ладно, я рад тебя слышать.", 5);
	get_node("dialog_2").play();
	yield(get_tree().create_timer(5), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "Я так понимаю, твоему информатору не повезло. В городе творится какой-то бардак, будь осторожнее.", 7);
	get_node("dialog_3").play();
	yield(get_tree().create_timer(7), "timeout");
	_title.say("У меня день начался с побега из-под дула пистолета КГБшника, так что я немного в курсе.", 5.5);
	yield(get_tree().create_timer(5.5), "timeout");
	_title.say("Причина переполоха известна?", 3);
	yield(get_tree().create_timer(3), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "По-видимому, у советов произошла какая-то утечка, которую они пытаются срочно заткнуть.", 7);
	get_node("dialog_4").play();
	yield(get_tree().create_timer(7), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "Держи ушки на макушке, если вдруг тебе попадутся интересные файлы или перебежчики с востока.", 7);
	get_node("dialog_5").play();
	yield(get_tree().create_timer(7), "timeout");
	if get_parent().get_parent().note:
		_title.say("Ясно. Тут от информатора осталась наводка на какой-то клуб.", 4);
		yield(get_tree().create_timer(4), "timeout");
		_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "Отлично! Тогда отправляйся туда и узнай, кому там нужны услуги кислотного агента.", 7);
		get_node("dialog_6").play();
		yield(get_tree().create_timer(7), "timeout");
	else:
		_title.say("Ясно. Как быть с информатором? Мертвецы не делятся тайнами.", 4);
		yield(get_tree().create_timer(4), "timeout");
		_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "Осмотрись. Может он оставил что-то. Ты же кислотный агент, должен липнуть к зацепкам сильнее, чем рок-звёзды к кокаину.", 10.5);
		get_node("dialog_7").play();
		yield(get_tree().create_timer(10.5), "timeout");
	_subtitle.say(get_parent().get_parent().get_node("room/column/dialog"), "Удачи!", 2);
	get_node("dialog_8").play();
	yield(get_tree().create_timer(2), "timeout");
	talking = false;
	drop();

func drop():
	if not talking:
	#mode = RigidBody.MODE_RIGID;
	#add_central_force(Vector3(0, 64, -192).rotated(Vector3.UP, get_parent().rotation.y));
	#get_node("collision").disabled = false;
		taken = false;
		var _position = global_translation;
		var _rotation = global_rotation;
		var _parent = get_parent().get_parent().get_node("objects");
		get_parent().object = null;
		get_parent().remove_child(self);
		_parent.add_child(self);
		global_translation = _position;
		global_rotation = _rotation;
		var _tween = get_tree().create_tween();
		_tween.parallel().tween_property(self, "translation", Vector3(-2.925, 1.3, 8.5), 1).set_trans(Tween.TRANS_SINE);
		_tween.parallel().tween_property(self, "rotation", Vector3.ZERO, 1).set_trans(Tween.TRANS_SINE);
		yield(get_tree().create_timer(1), "timeout");
		get_parent().get_parent().phone = true;
