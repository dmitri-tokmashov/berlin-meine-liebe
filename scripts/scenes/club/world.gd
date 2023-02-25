extends Spatial;

var code = [];
var state = 0;

onready var icon = get_node("player/icon");
onready var camera = get_node("player/camera");
onready var player = get_node("player");
onready var taxi = get_node("taxi");
onready var objects = {"bottle": get_node("objects/bottle"), "bouncer": get_node("objects/bouncer"), "chief": get_node("objects/chief"), "door": get_node("objects/door"), "kitchen": get_node("objects/kitchen"), "lock": get_node("objects/lock"), "office": get_node("objects/office"), "card": get_node("objects/card"), "chillzone": get_node("objects/chillzone")};

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0);
	#get_node("outro/holder/Camera").queue_free();
	get_node("road").queue_free();
	get_node("club/light_3").queue_free();
	character.initialize("chief", "smoking", objects.chief.get_node("model"));
	character.initialize("man_1", "standing", objects.bouncer.get_node("model"));
	character.initialize("man_2", "standing", get_node("street/man_1"));
	character.initialize("man_0", "standing", get_node("street/man_2"));
	character.initialize("woman_0", "standing", get_node("street/woman_1"));
	character.initialize("woman_1", "standing", get_node("street/woman_2"));
	character.initialize("slon", "sitting", get_node("club/upstairs/office/slon"));
	get_node("club/stage/model_1").get_active_material(4).albedo_texture = get_node("club/stage/video").get_viewport().get_texture();
	get_node("club/stage/model_1").get_active_material(4).emission_texture = get_node("club/stage/video").get_viewport().get_texture();
	player.remove_child(icon);
	add_child(icon);
	var _timer = get_tree().create_timer(2.0);
	_timer.connect("timeout", self, "_taxi");

func _process(delta):
	_objects();
	_music();

func _physics_process(delta):
	_icons(delta);

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and player.target.size() > 0:
			if player.action == "take":
				if not is_instance_valid(player.object):
					player.target.collider.take(player);
				else:
					player.target.collider.use(player);
				#player.target.collider.take(player);
			elif player.action == "talk":
				if not is_instance_valid(player.object):
					player.target.collider.talk(player);
				else:
					player.target.collider.use(player);
		elif event.button_index == BUTTON_RIGHT and player.object != null:
			player.object.drop();
	#if state == 3 and event is InputEventKey:
#	if event is InputEventKey:
#		#if event.pressed and ([KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0].has(event.scancode) or [KEY_KP_0, KEY_KP_1, KEY_KP_2, KEY_KP_3, KEY_KP_4, KEY_KP_5, KEY_KP_6, KEY_KP_7, KEY_KP_8, KEY_KP_9].has(event.scancode)):
#		if event.pressed and ([KEY_3].has(event.scancode)):
#			meeting();
#		elif event.pressed and ([KEY_4].has(event.scancode)):
#			_chase();
#			$button.play();
#			if event.scancode > 57:
#				code.append(event.scancode - 16777302);
#			else:
#				code.append(event.scancode);
#			#else:
#				#pass;
#			if code == [52, 53, 49]:
#				code = [];
#				$granted.play();
#				state = 4;
#				var tween = get_tree().create_tween();
#				tween.parallel().tween_property(get_node("curtain"), "color", Color(0, 0, 0, 1), 1);
#				yield(get_tree().create_timer(1), "timeout");
#				tween = get_tree().create_tween();
#				get_node("screen").text = "Конец демоверсии\nСпасибо за прохождение, анон!";
#				tween.parallel().tween_property(get_node("screen"), "modulate", Color(1, 1, 1, 1), 1);
#				yield(get_tree().create_timer(5), "timeout");
#				get_tree().quit();
#			if code.size() > 2:
#				code = [];
#				$denied.play();

func _icons(delta):
	player.target = get_world().direct_space_state.intersect_ray(camera.global_translation, camera.to_global(Vector3(0, 0, -1.75)), [player]);
	#get_node("Label").text = str(player.target);
	if player.target.size() > 0 and objects.values().has(player.target.collider) and ((player.target.collider.type == "talk" and player.target.collider.active) or (player.target.collider.type != "talk")):
		#if player.action != player.target.collider.type:
		player.action = player.target.collider.type;
		if player.target.collider is StaticBody and player.object is RigidBody:
			#if player.action == "talk" and player.object != null:
			icon.texture = player.icons["use"];
		else:
			icon.texture = player.icons[player.action];
		if player.action == "take":
			icon.modulate = Color(0.875, 0.25, 0.875, icon.modulate.a + (1 - icon.modulate.a) * 8 * delta);
		if player.action == "talk":
			icon.modulate = Color(0.25, 0.875, 0.875, icon.modulate.a + (1 - icon.modulate.a) * 8 * delta);
		icon.translation += ((player.target.position + (player.to_global(Vector3(0, 0.7, 0.25)) - player.target.position) / 2) - icon.global_translation) * 2 * delta;
	else:
		player.target = {};
		if icon.modulate.a > 0.005:
			icon.modulate.a += (0 - icon.modulate.a) * 8 * delta;
			icon.translation += (player.to_global(Vector3(0, 0.7, 0.25)) - icon.translation) * 4 * delta;
		else:
			icon.modulate.a = 0;
			icon.translation = player.to_global(Vector3(0, 0.7, 0.25));
	icon.scale = Vector3.ONE * (0.5 + icon.modulate.a / 2);

func _taxi():
	get_node("curtain").color.a = 0;
	get_node("screen").modulate.a = 0;
	#var tween = get_tree().create_tween();
	#tween.parallel().tween_property(get_node("curtain"), "color", Color(0, 0, 0, 0), 2);
	#tween.parallel().tween_property(get_node("screen"), "modulate", Color(1, 1, 1, 0), 2);
	yield(get_tree().create_timer(2), "timeout");

	taxi.set_engine_force(75);
	taxi.get_node("sound").play();
	yield(get_tree().create_timer(10.0), "timeout");
	taxi.queue_free();

func _objects():
	if state == 0:
		if player.translation.x < 8:
			if player.translation.z < 2:
				get_node("club/light_1").visible = false;
			else:
				get_node("club/light_1").visible = true;
		if player.translation.x > 30:
			if player.translation.z > -8:
				get_node("club/kitchen/light_1").visible = true;
			else:
				get_node("club/kitchen/light_1").visible = false;

func _music():
	#if state == 0:
	if state == 1:
		if player.translation.x > 23 and player.translation.z < -6:
			$club/inside.unit_db = -30 + (30 - player.translation.x) / 7 * 35;
			$club/outside.unit_db = 20 - (35 + $club/inside.unit_db);
		else:
			$club/inside.unit_db = 5;
			$club/outside.unit_db = -60;
	if player.translation.y < 1:
		if player.translation.z > -1:
			if player.translation.x > 8 and player.translation.x < 11:
				if player.translation.z > -1 and player.translation.z < 5:
					$club/inside.unit_db = 5 - (player.translation.z + 1) / 6 * 40;
					$club/outside.unit_db = 20 - (35 + $club/inside.unit_db) * 1.5;
			elif player.translation.x >= 11:
				$club/inside.unit_db = 5;
				$club/outside.unit_db = -60;
			else:
				$club/inside.unit_db = -60;
				$club/outside.unit_db = 20;
		elif player.translation.x < 8:
			$club/outside.unit_db = 5 + 15 * (player.translation.z + 9) / 8;

func meeting():
	var _translation = camera.global_translation;
	var _rotation = camera.global_rotation;
	player.remove_child(camera);
	add_child(camera);
	camera.global_translation = _translation;
	camera.global_rotation = _rotation;
	var tween = get_tree().create_tween();
	tween.parallel().tween_property(camera, "translation", Vector3(23.6, 4, -7.4), 12).set_trans(Tween.TRANS_SINE);
	tween.parallel().tween_property(camera, "rotation_degrees", Vector3(0, -90, 0), 1.5).set_trans(Tween.TRANS_SINE);
	tween.parallel().tween_property(camera, "fov", 15.0, 8).set_trans(Tween.TRANS_SINE);
	tween.parallel().tween_method(self, "change_sounds_volume", 0, -45, 12).set_trans(Tween.TRANS_SINE);
	get_node("lady").play();
	get_node("club/upstairs/chillzone/lady_1").visible = true;
	get_node("club/upstairs/chillzone/lady_1/AnimationPlayer").play("default");
	get_node("club/upstairs/chillzone/lady_1/AnimationPlayer").playback_speed = 0.25;
	#tween.parallel().tween_property(camera, "fov", 30.0, 1.5).set_trans(Tween.TRANS_SINE);
	yield(get_tree().create_timer(10.5), "timeout");
	get_node("hearts/viewport/particless").emitting = true;
	yield(get_tree().create_timer(1), "timeout");
	tween = get_tree().create_tween();
	tween.parallel().tween_property(get_node("curtain"), "color", Color(0, 0, 0, 1), .5);
	yield(get_tree().create_timer(.55), "timeout");
	get_node("club/upstairs/chillzone/lady_1").queue_free();
	get_node("club/upstairs/chillzone/lady_2").visible = true;
	get_node("club/upstairs/chillzone/lady_2/AnimationPlayer").play("default");
	player.translation = Vector3(27.4, 4, -7.7);
	player.rotation_degrees.y = -110;
	remove_child(camera);
	player.add_child(camera);
	camera.translation = Vector3(0, 0.75, 0);
	camera.rotation = Vector3.ZERO;
	camera.fov = 70;
	get_node("club").delete_characters_inside();
	tween = get_tree().create_tween();
	tween.parallel().tween_property(get_node("curtain"), "color", Color(0, 0, 0, 0), .5);
	#get_parent().get_parent().state = 3;

	tween.parallel().tween_method(self, "change_sounds_volume", -45, 0, 5).set_trans(Tween.TRANS_SINE);

	var _title = get_node("title");
	var _subtitle = get_node("subtitle");
	yield(get_tree().create_timer(1), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Привет!", 2);
	yield(get_tree().create_timer(2), "timeout");
	_title.say("Здравствуй…", 2.5);
	get_node("club/upstairs/chillzone/lady_2/dialog_1").play();
	yield(get_tree().create_timer(2.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Это ты должен меня отвезти на восток?", 3);
	get_node("club/upstairs/chillzone/lady_2/dialog_2").play();
	yield(get_tree().create_timer(3), "timeout");
	_title.say("Эм… Да! Это я.", 2);
	yield(get_tree().create_timer(2), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "С тобой всё в порядке? А, ну да, ты же кислотник.", 3.5);
	get_node("club/upstairs/chillzone/lady_2/dialog_3").play();
	yield(get_tree().create_timer(3.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Тогда я просто введу тебя в курс дела.", 3);
	get_node("club/upstairs/chillzone/lady_2/dialog_4").play();
	yield(get_tree().create_timer(3), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Ах да! Я не представилась. Извини. Меня зовут Люба. Русское имя, означает любовь.", 5.5);
	get_node("club/upstairs/chillzone/lady_2/dialog_5").play();
	yield(get_tree().create_timer(5.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Я перебежчица с востока, раньше участвовала в проектах Ленинградского НИИ Робототехники.", 5);
	yield(get_tree().create_timer(5), "timeout");
	_title.say("И тебе нужно на восток?", 2.5);
	yield(get_tree().create_timer(2.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Это странно? У меня осталось важное дело в ГДР.", 3.5);
	yield(get_tree().create_timer(3.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Нужно забрать кое-какие данные из одного старого бункера.", 4);
	yield(get_tree().create_timer(4), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Его использовали в 70-ые для сохранения научных данных на случай ядерной войны.", 4.5);
	yield(get_tree().create_timer(4.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Меня должен будет встретить один мой доверенный товарищ. Всё что от тебя требуется - обеспечить мою безопасность на время пребывания в Восточном Берлине.", 8);
	yield(get_tree().create_timer(8), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Кислотные агенты ведь ни на чьей стороне? Я надеюсь, тебе можно доверять.", 4.5);
	yield(get_tree().create_timer(4.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Слушай, я не чувствую себя в безопасности даже в Западном Берлине.", 4);
	yield(get_tree().create_timer(4), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Кажется, что янки могут быть не менее опасны, чем советы.", 4);
	yield(get_tree().create_timer(4), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Эй, а что с дверью?", 2);
	get_node("objects/chillzone/animation").play_backwards("open");
	get_node("objects/chillzone/sound").play();
	yield(get_tree().create_timer(3), "timeout");
	#_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Извините, ребятки. Нужно вас тут придержать, пока не приедут люди из БНД.", 4.5);
	#yield(get_tree().create_timer(4.5), "timeout");
	_title.say("Видимо Слон решил нас наебать, закрыть тут и сдать тебя БНД.", 6);
	yield(get_tree().create_timer(6), "timeout");
#	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Парень! Ни я, ни ты, ни она — никто не знает, куда ей нужно.", 4);
#	yield(get_tree().create_timer(4.5), "timeout");
#	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Всё ясно, он лёг под запад.", 2.5);
#	yield(get_tree().create_timer(2.5), "timeout");
	_subtitle.say(get_node("club/upstairs/chillzone/lady_2"), "Но мне нужно отсюда убраться!", 3);
	yield(get_tree().create_timer(3), "timeout");
	_title.say("Хорошо. Спустимся по трубе, и спиздим его Porsche.", 3);
	yield(get_tree().create_timer(3), "timeout");
	tween = get_tree().create_tween();
	tween.parallel().tween_property(get_node("curtain"), "color", Color(0, 0, 0, 1), .5);
	yield(get_tree().create_timer(0.5), "timeout");
	_chase();

func _chase():
	get_node("club/upstairs/chillzone/lady_2").visible = false;
	#get_node("road").visible = true;
	#get_node("road/collision_1").disabled = false;
	#get_node("road/collision_2").disabled = false;
	#get_node("road/collision_3").disabled = false;

	player.remove_child(camera);
	get_node("outro/holder").add_child(camera);
	camera.translation = Vector3.ZERO;
	camera.rotation = Vector3.ZERO;
	get_node("outro/animation").play("outro");

	get_node("vehicle_1").mode = RigidBody.MODE_RIGID;
	#get_node("vehicle_1/collision").disabled = false;
	#get_node("vehicle_1").translation.y = 2;
	get_node("vehicle_1").set_steering(deg2rad(20));
	get_node("vehicle_1").set_engine_force(125);
	yield(get_tree().create_timer(1.75), "timeout");
	get_node("vehicle_1").set_steering(deg2rad(1));
	yield(get_node("outro/animation"), "animation_finished");
	get_parent().load_level("final");

#	get_node("vehicle_1").translation.x = 0;
#	#get_node("vehicle_1").translation.y = 513;
#	get_node("vehicle_1").translation.z = -96;
#	#get_node("vehicle_1").translation = Vector3(0, 513, 0);
#	get_node("vehicle_1").rotation_degrees.y = 180;
#	#get_node("vehicle_1").set_engine_force(250);
#	remove_child(player);
#	player.get_node("collision").disabled = true;
#	get_node("vehicle_1/model").add_child(player);
#	player.translation = Vector3(2.5, 0, -0.5);
#	camera.fov = 45;
#	#yield(get_tree().create_timer(1.75), "timeout");
#	#get_node("vehicle_1").translation = Vector3(0, 513, 0);

func change_sounds_volume(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), value);
