extends Spatial

var bridges: int = 0;
var data = [
	[Vector3(3.5, 3.5, -2.5), Vector3(8, 3.5, 0), Vector3(6, 3.5, -2.5)],
	[[0, Vector3(3.5, 0, 0)], [1, Vector3(6.25, 0, -5), 16000, 128], [2, Vector3(8.5, 0, -11.5), 10000, 96], [3, Vector3(6.5, 0, -18), 12000, 64], [1, Vector3(4, 0, -26)], [4, Vector3(6.75, 0, -35.75), 8000, 256], [2, Vector3(9.5, 0, -42), 12000, 64], [3, Vector3(9, 0, -52), 8000, 256], [1, Vector3(6.5, 0, -58), 12000, 256], [4, Vector3(9.5, 0, -65), 10000, 192], [1, Vector3(12, 0, -74)]],
	[[1, Vector3(8, 0, 0)], [3, Vector3(7, 0, -9), 16000, 128], [2, Vector3(6, 0, -16), 10000, 64], [4, Vector3(9, 0, -25)], [2, Vector3(6.75, 0, -34), 8000, 256], [4, Vector3(3.5, 0, -42), 12000, 64], [3, Vector3(9, 0, -48), 8000, 256], [1, Vector3(6.5, 0, -56), 12000, 256], [4, Vector3(9.5, 0, -63), 10000, 192], [1, Vector3(12, 0, -72)]],
	[[1, Vector3(6, 0, 0)], [4, Vector3(4, 0, 8), 16000, 128], [2, Vector3(8.5, 0, 16), 10000, 96], [3, Vector3(6.5, 0, 22), 12000, 32], [1, Vector3(3.5, 0, 30)], [2, Vector3(6.5, 0, 40), 8000, 128], [3, Vector3(9.5, 0, 45), 12000, 128], [1, Vector3(7, 0, 54), 8000, 256], [2, Vector3(9, 0, 62), 12000, 256], [1, Vector3(12, 0, 70)]]
];
var state: int = -1;
var _bus: Material = load("res://materials/vehicles/traffic/bus.material");
var _time: float = 0.0;
var _translation: float;
var _turn: bool = false;
var _win: bool = false;
onready var autobahn = get_node("autobahn");
onready var traffic = get_node("traffic");
onready var transport = get_node("transport");
onready var vehicles = [get_node("transport/vehicle_1").duplicate(), get_node("transport/vehicle_2").duplicate(), get_node("transport/vehicle_3").duplicate(), get_node("transport/vehicle_4").duplicate(), get_node("transport/vehicle_5").duplicate()];
onready var player = get_node("player");
onready var camera = get_node("player/camera");
onready var road = get_node("autobahn").duplicate();
onready var _sign = get_node("sign");

func _ready():
	player.move = false;
	var _instance: Spatial;
	for node in (autobahn.get_children() + transport.get_children()):
		node.get_parent().remove_child(node);
		node.queue_free();
	for index in range(24):
		_instance = road.duplicate();
		for string in ["bridge", "support_1", "support_2"]:
			_instance.get_node(string).visible = false;
		autobahn.add_child(_instance);
		_instance.get_node("area").connect("body_entered", self, "_fail");
		_instance.translation.z = 192 - index * 64;
	for index in autobahn.get_child_count() * 3:
		_instance = vehicles[1 + randi() % 4].duplicate();
		traffic.add_child(_instance);
		_instance.rotation_degrees.y = 180;
		_instance.translation.x = rand_range(-12, -3.5);
		_instance.translation.z = 192 - index * 24;
	remove_child(_sign);
	autobahn.add_child(_sign);
	_sign.translation.z = -192;
	_create(0);
	get_node("area").connect("body_entered", self, "_fail");
	#$music.play(42);
	opening();

func opening():
	player.remove_child(camera);
	get_node("holder").add_child(camera);
	camera.translation = Vector3.ZERO;
	get_node("animation").play("intro");
	#get_node("holder").rotation_degrees = Vector3(54, 0, 0);
	#camera.rotation = Vector3.ZERO;
	get_node("garbage/particless").emitting = true;
	get_node("screen").texture = get_node("garbage").get_texture();
	get_node("screen").visible = true;
	#yield(get_tree().create_timer(4), "timeout");
	#get_node("animation").play("intro");
	yield(get_node("animation"), "animation_finished");
	get_node("screen").visible = false;
	get_node("holder/logo").queue_free();
	var _title = get_node("title");
	_title.say("Так-с, какой там у меня список дел на сегодня?", 2);
	get_node("holder").remove_child(camera);
	player.add_child(camera);
	camera.translation = Vector3(0, 0.75, 0);
	player.get_node("animation").play("show");
	yield(get_tree().create_timer(4), "timeout");
	player.get_node("animation").play_backwards("show");
	player.move = true;
	state = 0;
	_title.say("Ясно, нужно поймать попутку до Бойссельштрассе.", 2.5);

func _create(stage):
	var _instance: Spatial;
	#if stage == 0:
	var _check = transport.get_children();
	for _data in data[stage + 1]:
		_instance = vehicles[_data[0]].duplicate();
		transport.add_child(_instance);
		_instance.translation = _data[1];
	transport.get_child(transport.get_child_count() - 1).get_node("model").set_surface_material(0, _bus);
	transport.get_child(transport.get_child_count() - 1).get_node("area").connect("body_entered", self, "_road");
	transport.get_child(transport.get_child_count() - 1).get_node("area/collision").disabled = false;
	_sign.get_node("label").text = "БОЙССЕЛЬ\nШТРАССЕ\n\n" + str(6 - stage * 2) + " КМ";
	_sign.get_node("arrow_1").visible = true;
	_sign.get_node("arrow_2").visible = false;

func _process(delta):
	if state < 4:
		traffic.translation.z += delta * 48;
		if traffic.translation.z > 1440:
			traffic.translation.z -= 1440;
		if state > -1:
			autobahn.translation.z += delta * 24;
			if state > 1 and _time >= (bridges + 1) * 9:
				if autobahn.get_child((bridges + 1)  * 4).get_child_count() == 6:
					bridges += 1;
					autobahn.get_child((bridges + 1)  * 4).get_node("road_1").visible = false;
					autobahn.get_child((bridges + 1)  * 4).get_node("road_2").visible = false;
					autobahn.get_child((bridges + 1)  * 4).get_node("bridge").visible = true;
					autobahn.get_child((bridges + 1)  * 4).get_node("support_1").visible = true;
					autobahn.get_child((bridges + 1)  * 4).get_node("support_2").visible = true;
					autobahn.get_child((bridges + 1)  * 4).get_node("area/collision").disabled = false;
				#autobahn.get_child(bridges * 3).get_node("bridge").visible = true;
			if _time >= 28 and not _turn:
				_road(player);
			else:
				_time += delta;
		_translation = 0;
		var _data;
		if state < 1:
			_data = data[1];
		else:
			_data = data[state];
		var _check = transport.get_child_count();
		for index in transport.get_child_count():
			if index == 0 and state < 2:
				if state == 0 and player.translation.x > 5.5:
					state = 1;
				if state == 1:
					transport.get_children()[index].translation.z += 4 * delta;
			if _data[index].size() > 2:
				_translation = sin(2 * PI * fmod(OS.get_ticks_msec(), _data[index][2]) / _data[index][2]) / _data[index][3];
				transport.get_children()[index].translation.z += _translation;
				if player.get_node("ray").get_collider() == transport.get_children()[index]:
					player.translation.z += _translation;
	get_node("Label").text = str(_time);

func _restart(win):
	var _instance: Spatial;
	autobahn.translation.z = 0;
	traffic.translation.z = 0;
	for node in get_node("autobahn").get_children():
		if node.get_child_count() == 6:
			node.get_node("road_1").visible = true;
			node.get_node("road_2").visible = true;
			node.get_node("bridge").visible = false;
			node.get_node("support_1").visible = false;
			node.get_node("support_2").visible = false;
			node.get_node("area/collision").disabled = true;
	bridges = 0;
	if state == 1:
		transport.get_children()[0].translation = Vector3(3.5, 0, 0);
		#state = 0;
	_sign.translation.z = -192;
	if _turn:
		_instance = autobahn.get_node("turn");
		_instance.visible = false;
		_instance.get_node("area").disconnect("body_entered", self, "_turn");
		autobahn.remove_child(_instance);
		add_child(_instance);
		_turn = false;
	_time = 0;
	if win and state < 3:
		state += 1;
		for node in get_node("transport").get_children():
			node.queue_free();
		_create(state - 1);
	elif state < 2:
		state = 0;
	if state > 0:
		player.translation = data[0][state - 1];
	else:
		player.translation = data[0][0];
	player.rotation_degrees = Vector3.ZERO;
	player.get_node("camera").rotation_degrees = Vector3.ZERO;

func _road(body):
	if body is KinematicBody and not _turn:
		var _instance: Spatial;
		_turn = true;
		#yield(get_tree().create_timer(5), "timeout");
		_instance = get_node("turn");
		remove_child(_instance);
		autobahn.add_child(_instance);
		_instance.translation.z = -autobahn.translation.z - 176;
		_instance.visible = true;
		_instance.get_node("area").connect("body_entered", self, "_turn");
		_sign.translation.z = -autobahn.translation.z - 176;
		_sign.get_node("label").text = "БОЙССЕЛЬ\nШТРАССЕ\n\n" + str(7 - state * 2) + " КМ";
		_sign.get_node("arrow_1").visible = false;
		_sign.get_node("arrow_2").visible = true;
		#yield(get_tree().create_timer(5), "timeout");
		#_turn(transport.get_child(transport.get_child_count() - 1).get_node("area").get_overlapping_bodies().has(player));

func _turn(bus):
	if bus == transport.get_child(transport.get_child_count() - 1):
		var _win = bus.get_node("area").get_overlapping_bodies().has(player);
		player.move = false;
		player.translation = Vector3(0, 8192, 0);
		if _win:
			get_node("scenes/turn/background").get_active_material(0).albedo_color = Color8(0, 112, 64);
		else:
			get_node("scenes/turn/background").get_active_material(0).albedo_color = Color8(240, 0, 240);
		get_node("scenes/turn/camera").current = true;
		get_node("screen").rect_position = Vector2(0, -OS.window_size.y);
		#get_node("screen").rect_position.x = 0;
		var tween = get_tree().create_tween();
		tween.tween_property(get_node("screen"), "rect_position", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_SINE);
		get_node("screen").texture = get_node("scenes").get_texture();
		get_node("screen").visible = true;
		get_node("scenes/turn").visible = true;
		get_node("scenes/turn/animation").play("default");
		yield(get_tree().create_timer(1.25), "timeout");
		#state = 3;
		#_win = true;
		if state < 3 or (state == 3 and not _win):
			_restart(_win);
		else:
			state += 1;
		if _win:
			tween = get_tree().create_tween();
			if state < 4:
				tween.tween_property(get_node("screen"), "rect_position", Vector2(-OS.window_size.x, 0), 0.5).set_trans(Tween.TRANS_SINE);
				yield(get_tree().create_timer(0.5), "timeout");
				player.move = true;
			else:
				tween.tween_property(get_node("screen"), "rect_position", Vector2(-OS.window_size.x, 0), 1).set_trans(Tween.TRANS_SINE);
				#yield(get_tree().create_timer(1), "timeout");
				for node in get_node("autobahn").get_children() + get_node("transport").get_children():
					node.queue_free();
				player.remove_child(camera);
				get_node("outro/holder").add_child(camera);
				camera.translation = Vector3.ZERO;
				camera.rotation = Vector3.ZERO;
				get_node("outro/animation").play("outro");
				yield(get_tree().create_timer(3), "timeout");
				get_parent().load_level("safehouse");
			#tween = get_tree().create_tween();
			#tween.tween_property(get_node("scenes/turn/background").get_active_material(0), "albedo_color", Color8(240, 0, 240, 0), 0.5).set_trans(Tween.TRANS_SINE);
		else:
			tween = get_tree().create_tween();
			tween.tween_property(get_node("scenes/turn/background").get_active_material(0), "albedo_color", Color8(240, 0, 240, 0), 0.5).set_trans(Tween.TRANS_SINE);
			yield(get_tree().create_timer(0.5), "timeout");
			player.move = true;
			tween = get_tree().create_tween();
			tween.tween_property(get_node("screen"), "modulate", Color8(255, 255, 255, 0), 0.5).set_trans(Tween.TRANS_SINE);
			yield(get_tree().create_timer(0.5), "timeout");
		if state < 4:
			get_node("scenes/turn").visible = false;
			get_node("scenes/turn/background").get_active_material(0).albedo_color.a = 1;
			get_node("screen").visible = false;
			get_node("screen").modulate.a = 1;

func _fail(body):
	if body is KinematicBody and state < 4:
		player.move = false;
		player.translation = Vector3(0, 8192, 0);
#		if type == 1:
		get_node("scenes/fail/camera").translation = Vector3(0, 7.5, 0);
		get_node("scenes/fail/camera").rotation_degrees = Vector3(-90, -90 , 0);
		get_node("scenes/fail/camera").current = true;
		get_node("scenes/fail/background").visible = true;
		get_node("scenes/fail/background_2").visible = false;
		get_node("screen").rect_position = Vector2(0, -OS.window_size.y);
#		elif type == 2:
#			get_node("fail/screen/scene/camera").translation = Vector3(-6, 1.5, 0);
#			get_node("fail/screen/scene/camera").rotation_degrees = Vector3(0, -90 , -90);
#			get_node("fail/screen/scene/background_1").visible = false;
#			get_node("fail/screen/scene/background_2").visible = true;
#			get_node("fail").rect_position.x = OS.window_size.x;
		var tween = get_tree().create_tween();
		tween.tween_property(get_node("screen"), "rect_position", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_SINE);
		get_node("scenes/fail/player/AnimationPlayer").play("default");
		get_node("scenes/fail").visible = true;
		get_node("scenes/fail/animation").play("default");
		get_node("screen").texture = get_node("scenes").get_texture();
		get_node("screen").visible = true;
		yield(get_tree().create_timer(1), "timeout");
		get_node("scenes/fail/blood").visible = true;
		tween = get_tree().create_tween();
		#get_node("fail/screen/scene/blood").get_active_material(0).albedo_color
		tween.tween_property(get_node("scenes/fail/background").get_active_material(0), "albedo_color", Color8(240, 0, 240, 0), 1).set_trans(Tween.TRANS_SINE);
		_restart(false);
		yield(get_tree().create_timer(1), "timeout");
		tween = get_tree().create_tween();
		tween.tween_property(get_node("screen"), "modulate", Color8(255, 255, 255, 0), 0.5).set_trans(Tween.TRANS_SINE);
		yield(get_tree().create_timer(0.5), "timeout");
		player.move = true;
		get_node("scenes/fail").visible = false;
		get_node("scenes/fail/blood").visible = false;
		get_node("scenes/fail/background").get_active_material(0).albedo_color.a = 1;
		get_node("screen").visible = false;
		get_node("screen").modulate.a = 1;
