extends Spatial;

var note = false;
var phone = false;
var curtain = false;
onready var icon = get_node("player/icon");
onready var player = get_node("player");
onready var camera = player.get_node("camera");
onready var objects = {"door": get_node("objects/door"), "phone": get_node("objects/phone"), "note": get_node("objects/note")};

func _ready():
	player.remove_child(icon);
	add_child(icon);
	get_node("room/column/phone/wire").set("attachments/2/offset", Vector3(0, 0, -0.01));
	get_node("room/column/phone/wire").set("attachments/3/offset", Vector3(0, 0, 0.01));
	get_node("room/man_1/AnimationPlayer").play("default");
	get_node("room/man_2/AnimationPlayer").play("default");
	_intro();

func _physics_process(delta):
	_icons(delta);
	if note and phone and not curtain:
		curtain = true;
		_curtain();

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
		icon.translation += ((player.target.position + (player.to_global(Vector3(0, 0.7, 0.25)) - player.target.position) / 2) - icon.global_translation) * 4 * delta;
	else:
		player.target = {};
		if icon.modulate.a > 0.005:
			icon.modulate.a += (0 - icon.modulate.a) * 8 * delta;
			icon.translation += (player.to_global(Vector3(0, 0.7, 0.25)) - icon.translation) * 4 * delta;
		else:
			icon.modulate.a = 0;
			icon.translation = player.to_global(Vector3(0, 0.7, 0.25));
	icon.scale = Vector3.ONE * (0.5 + icon.modulate.a / 2);

func _intro():
	player.move = false;
	player.remove_child(camera);
	get_node("holder").add_child(camera);
	camera.translation = Vector3.ZERO;
	get_node("holder/animation").play("scene");
	var tween = get_tree().create_tween();
	tween.parallel().tween_method(self, "change_music_volume", -60, -5, 2).set_trans(Tween.TRANS_SINE);
	get_node("music").play();
	yield(get_tree().create_timer(3), "timeout");
	get_node("elevator/animation").play("default");
	tween = get_tree().create_tween();
	tween.parallel().tween_method(self, "change_music_volume", -5, -20, 12).set_trans(Tween.TRANS_SINE);
	yield(get_tree().create_timer(3.5), "timeout");
	get_node("elevator").queue_free();
	get_node("wall_4").visible = true;
	get_node("holder").remove_child(camera);
	player.add_child(camera);
	player.translation = Vector3(0, 0.8, -5.25);
	player.rotation_degrees = Vector3(0, 180, 0);
	player.move = true;
	camera.translation = Vector3(0, 0.75, 0);

func _curtain():
	yield(get_tree().create_timer(1), "timeout");
	var _title = get_node("title");
	_title.say("Значит еду тусить в Декаданс…", 2);
	yield(get_tree().create_timer(1), "timeout");
	var tween = get_tree().create_tween();
	tween.parallel().tween_property(get_node("curtain"), "color", Color(0, 0, 0, 1), 2).set_trans(Tween.TRANS_SINE);
	tween.parallel().tween_method(self, "change_music_volume", -20, -60, 4).set_trans(Tween.TRANS_SINE);
	yield(get_tree().create_timer(4), "timeout");
	get_parent().load_level("club");

func change_music_volume(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value);
