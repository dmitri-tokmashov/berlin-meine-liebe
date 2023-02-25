extends Spatial

var bonuses = [];
var bonus_list = [[], [], [], [], []];
var runners = [];
var ledges = [];
var props = [];
var sounds = [[], [], [], [], [], []];
var skins = [[], [], []];
var stage = 1;
var status = -1;
var body_count;
var last_runner;
onready var player = get_node("runner");
onready var camera = get_parent().get_node("camera");
onready var skull = get_node("skull");
onready var game = get_parent();
onready var interface = get_parent().get_node("interface");

func _ready():
	sounds[0].append(load("res://sounds/ouch_0.ogg"));
	sounds[0].append(load("res://sounds/ouch_1.ogg"));
	sounds[1].append(load("res://sounds/punch_0.ogg"));
	sounds[1].append(load("res://sounds/punch_1.ogg"));
	sounds[2].append(load("res://sounds/fart_0.ogg"));
	sounds[2].append(load("res://sounds/fart_1.ogg"));
	sounds[3].append(load("res://sounds/laugh_0.ogg"));
	sounds[4].append(load("res://sounds/slide.ogg"));
	sounds[5].append(load("res://sounds/teleport.ogg"));
	#skins[0].append([]);
	#skins[0].append([load("res://materials/crew_orange/body.material"), load("res://materials/crew_orange/backpack.material")]);
	#skins[0].append([load("res://materials/crew_pink/body.material"), load("res://materials/crew_pink/backpack.material")]);
	#skins[0].append([load("res://materials/crew_green/body.material"), load("res://materials/crew_green/backpack.material")]);
	#skins[0].append([load("res://materials/crew_blue/body.material"), load("res://materials/crew_blue/backpack.material")]);
	#skins[0].append([load("res://materials/crew_purple/body.material"), load("res://materials/crew_purple/backpack.material")]);
	#skins[0].append([load("res://materials/crew_cyan/body.material"), load("res://materials/crew_cyan/backpack.material")]);
	$finish/area.connect("body_entered", self, "finish");
	_create_ledges();

func _process(delta):
	if status == 0:
		var _place: int = 1;
		var _last_runner;
		if last_runner.exclude:
			_last_runner = player;
		else:
			_last_runner = last_runner;
		for _runner in runners:
			if _runner.translation.z < player.translation.z:
				_place += 1;
			if _runner.translation.z > _last_runner.translation.z:
				_last_runner = _runner;
		if not (_last_runner == last_runner):
			last_runner = _last_runner;
		interface.get_node("position").get_node("text").text = str(_place) + "/" + str(runners.size());
		if runners.size():
			camera.translation = Vector3(player.translation.x, player.translation.y + 0.5, player.translation.z + 1.5);
		skull.translation = last_runner.translation + Vector3(0, 1.2, 0);
		bonuses(delta);

func _runners_spawn():
	body_count = 20 - 4 * stage;
	for _counter in range(body_count):
		if runners.size() != body_count:
			runners.append($runner.duplicate());
			add_child(runners[runners.size() - 1]);
			if runners.size() == 1:
				player = runners[0];
				player.control = true;
				player.exclude = false;
				runners[runners.size() - 1].translation = Vector3(0, 1, 8);
			else:
				runners[runners.size() - 1].control = false;
				runners[runners.size() - 1].translation = Vector3(0, 0, 1024);
			runners[runners.size() - 1].init();
	last_runner = player;
	_pole_position(1);
	#var _timer = get_tree().create_timer(0);
	#_timer.connect("timeout", self, "_runners_spawn");

func _pole_position(position):
	for _counter in range(4):
		if _counter + position < body_count:
			runners[_counter + position].translation = Vector3(-3 + 2 * ((_counter + position) % 4), runners.size(), 8 + 0 * floor((_counter + position) / 4));
	if position < body_count:
		var _timer = get_tree().create_timer(2);
		_timer.connect("timeout", self, "_pole_position", [position + 4]);

func _props_spawn(_stage):
	if status > -1 and stage == _stage:
		var _prop = $ball.duplicate();
		add_child(_prop);
		props.append(_prop);
		_prop.translation = Vector3(rand_range(-7, 7), 112, -100);
		_prop.mode = RigidBody.MODE_RIGID;
		_prop.init();
		_prop.get_node("sounds").stream = load("res://sounds/fall_0.ogg");
		_prop.get_node("sounds").play();
		if player.translation.z < -16.968:
			_prop = $barrel.duplicate();
			add_child(_prop);
			props.append(_prop);
			_prop.translation = Vector3(rand_range(-7, 7), 112, -100);
			_prop.mode = RigidBody.MODE_RIGID;
			_prop.init();
		if player.translation.z < -33.936:
			_prop = $bench.duplicate();
			add_child(_prop);
			props.append(_prop);
			_prop.translation = Vector3(rand_range(-7, 7), 112, -100);
			_prop.mode = RigidBody.MODE_RIGID;
			_prop.init();
		if player.translation.z < -50.904:
			_prop = $wagon.duplicate();
			add_child(_prop);
			props.append(_prop);
			_prop.translation = Vector3(rand_range(-7, 7), 112, -100);
			_prop.mode = RigidBody.MODE_RIGID;
			_prop.init();
		if player.translation.z < -67.872:
			_prop = $boat.duplicate();
			add_child(_prop);
			props.append(_prop);
			_prop.translation = Vector3(rand_range(-7, 7), 112, -100);
			_prop.mode = RigidBody.MODE_RIGID;
			_prop.init();
		if player.translation.z < -84.84:
			_prop = $ambulance.duplicate();
			add_child(_prop);
			props.append(_prop);
			_prop.translation = Vector3(rand_range(-7, 7), 128, -112);
			_prop.mode = RigidBody.MODE_RIGID;
			_prop.type = "ambulance";
			_prop.init();
		var _timer;
		if stage == 1:
			_timer = get_tree().create_timer(8);
		elif stage == 2:
			_timer = get_tree().create_timer(7);
		elif stage == 3:
			_timer = get_tree().create_timer(6);
		_timer.connect("timeout", self, "_props_spawn", [_stage]);

func _runner_exclude(phase):
	if status == 0:
		if phase == 0:
			$doll/sounds.play();
			var _timer = get_tree().create_timer(5);
			_timer.connect("timeout", self, "_runner_exclude", [1]);
		else:
			last_runner.exclude = true;
			last_runner.fall();
			runners.erase(last_runner);
			props.append(last_runner);
			if last_runner == player:
				status = 2;
				finish(player);
			#elif runners.size() == body_count - 8:
				#status = 1;
				#finish(player);
			else:
				var _timer;
				if stage == 1:
				 _timer = get_tree().create_timer(5);
				elif stage == 2:
					_timer = get_tree().create_timer(7.5);
				elif stage == 3:
					_timer = get_tree().create_timer(10);
				_timer.connect("timeout", self, "_runner_exclude", [0]);

func _termination():
	for _runner in runners:
		_runner.queue_free();
	#for _ledge in ledges:
		#_ledge.queue_free();
	for _prop in props:
		_prop.queue_free();
	runners = [];
	#ledges = [];
	for bonus in bonuses:
		if bonus.type == 1:
			bonus.model.queue_free();
	bonus_list = [[], [], [], [], []];
	bonuses = [];
	props = [];
	interface.get_node("status").visible = false;
	#if status == 2 or status == 0:
	Appodeal.hide_banner();
	if (stage == 4 and status == 1) or status == 2:
		if status == 1:
			Ads.show_run_win();
		#game.get_node("finish").set_process(true);
		#game.get_node("finish").visible = true;
		game.interface.menu_show();
		camera.translation = Vector3(0, 1.2, 24.8);
		stage = 1;
		status = -1;
		game.mode = 0;
		game.music.volume_change(-16, .5);
		game.load_mode(0);
		#queue_free();
		#interface.control_show(false);
	else:
		start();

func start():
	#game.mode = 1;
	$finish/line.visible = true;
	if stage == 1:
		interface.get_node("start").get_node("sound").play();
	elif stage == 3:
		$finish/cup.visible = true;
	interface.loading_show();
	#player.init();
	#runners.append(player);
	bonuses = [];
	_create_bonuses();
	status = 0;
	_runners_spawn();
	_props_spawn(stage);
	interface.loading_hide();
	interface.get_node("bonus").connect("pressed", player, "bonus");
	var _timer = get_tree().create_timer(20);
	_timer.connect("timeout", self, "_runner_exclude", [0]);
	game.music.stream = game.music.data[randi() % game.music.data.size()];
	game.music.reset();
	game.music.play();

func finish(body):
	if body == player and (status == 0 or status == 2):
		if status == 0:
			if stage < 3:
				status = -1;
				interface.get_node("status").text = "STAGE " + str(stage) + "\nCOMPLETE!";
				Ads.show_run_loss();
			else:
				status = 1;
				interface.get_node("status").text = "YOU ARE THE WINNER!";
				get_parent().add_cups(1);
				$sounds/cheer.play();
			stage += 1;
			$finish/confetti.emitting = true;
			game.music.volume_change(-96, .5);
			$finish2.play();
		#elif status == 1:
			#interface.get_node("status").text = "YOU ARE THE WINNER!";
			#stage += 1;
			#$finish/confetti.emitting = true;
			#$finish2.play();
		elif status == 2:
			interface.get_node("status").text = "YOU LOSE!";
			Ads.show_run_loss();
		interface.get_node("status").visible = true;
		interface.get_node("bonus").visible = false;
		var _timer = get_tree().create_timer(6);
		_timer.connect("timeout", self, "_termination");

func _create_ledges():
	var colors = [Color8(255, 0, 255), Color8(64, 64, 255), Color8(64, 255, 96), Color8(255, 224, 64), Color8(255, 128, 64), Color8(255, 32, 64)];
	var shape: RID = PhysicsServer.shape_create(PhysicsServer.SHAPE_BOX)
	PhysicsServer.shape_set_data(shape, Vector3(1, 0.707, 0.707));
	$arrows.multimesh.set_color_format(1);
	$arrows.multimesh.instance_count = 36;
	$ledges.multimesh.instance_count = 36;
	for _counter in range(36):
		ledges.append({"collision": PhysicsServer.body_create(0), "position": Vector3(_counter % 3 * 6 - 6, -_counter % 3 % 2 * 4.242 + 4.949 + 8.484 * (_counter / 3), 0)});
		ledges[-1].position.z = -ledges[-1].position.y;
		PhysicsServer.body_add_shape(ledges[-1].collision, shape);
		PhysicsServer.body_set_state(ledges[-1].collision, PhysicsServer.BODY_STATE_TRANSFORM, Transform.translated(ledges[-1].position));
		PhysicsServer.body_set_space(ledges[-1].collision, get_world().space);
		$arrows.multimesh.set_instance_color(_counter, colors[_counter / 6]);
		$arrows.multimesh.set_instance_transform(_counter, Transform.translated(ledges[-1].position + Vector3(0, 0, 0.75)));
		$ledges.multimesh.set_instance_transform(_counter, Transform.translated(ledges[-1].position));

func _create_bonuses():
	$bonuses/shining.multimesh.instance_count = 36;
	for _counter in range(36):
		$bonuses/shining.multimesh.set_instance_transform(_counter, Transform.translated(ledges[_counter].position + Vector3(0, 1.414, 0)));
		if rand_range(0, 10) < 11:
			if true:
				var _bonus = randi() % 5;
				bonus_list[_bonus].append(_counter);
				if _bonus < 2 and _bonus > 0:
					bonuses.append({"index": _counter, "type": _bonus, "model": get_node("bonuses/model_" + str(_bonus)).duplicate(), "position": ledges[_counter].position + Vector3(0, 0.8, 0)});
					add_child(bonuses[-1].model);
					bonuses[-1].model.translation += ledges[_counter].position + Vector3(0, 1, 0);
					bonuses[-1].model.visible = true;
					#ledges[ledges.size() - 1].get_node("bonus/model_" + str(_bonus)).visible = true;
				else:
					bonuses.append({"index": _counter, "type": _bonus, "position": ledges[_counter].position + Vector3(0, 0.8, 0)});
				#else:
					#ledges[ledges.size() - 1].get_node("bonus").type = _bonus;
	$bonuses/model_0.multimesh.instance_count = bonus_list[0].size();
	$bonuses/model_2.multimesh.instance_count = bonus_list[2].size();
	$bonuses/model_3.multimesh.instance_count = bonus_list[3].size();
	$bonuses/model_4.multimesh.instance_count = bonus_list[4].size();
	for _index in bonus_list[0]:
		$bonuses/model_0.multimesh.set_instance_transform(bonus_list[0].find(_index), Transform.translated(bonuses[_index].position + Vector3(0, 0.625, 0)));
	for _index in bonus_list[2]:
		$bonuses/model_2.multimesh.set_instance_transform(bonus_list[2].find(_index), Transform.translated(bonuses[_index].position + Vector3(0, 0.5, 0)));
	for _index in bonus_list[3]:
		$bonuses/model_3.multimesh.set_instance_transform(bonus_list[3].find(_index), Transform(Vector3(0.0254, 0, 0), Vector3(0, 0.0254, 0), Vector3(0, 0, 0.0254), bonuses[_index].position + Vector3(0, 0.5, 0)));
	for _index in bonus_list[4]:
		$bonuses/model_4.multimesh.set_instance_transform(bonus_list[4].find(_index), Transform.translated(bonuses[_index].position + Vector3(0, -0.164, 0)));

func bonuses(delta):
	var list = [];
	for bonus in bonuses:
		if bonus.type == 1:
			bonus.model.rotation.y += PI / 2 * delta;
		for cast in [Vector3(-1, 1.5, -1), Vector3(0, 1.5, 0), Vector3(1, 1.5, -1)]:
			$bonuses/ray.translation = bonus.position;
			$bonuses/ray.cast_to = cast;
			$bonuses/ray.force_raycast_update();
			if $bonuses/ray.is_colliding():
				if $bonuses.body_entered($bonuses/ray.get_collider(), bonus):
					list.append(bonus);
					break;
	for bonus in list:
		$bonuses/shining.multimesh.set_instance_transform(bonus.index, Transform.translated(Vector3(0, -10, 0)));
		bonuses.erase(bonus);
