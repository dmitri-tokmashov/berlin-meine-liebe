extends StaticBody;

var type: String = "take";
var texture = load("res://textures/furniture/locks/0/albedo_after.png");

func take(player: KinematicBody):
	get_node("collision").disabled = true;
	var _title = get_parent().get_parent().get_node("title");
	var _subtitle = get_parent().get_parent().get_node("subtitle");
	_title.say("Тут нужна ключ-карта.", 2.5);
	yield(get_tree().create_timer(2.5), "timeout");
	get_node("collision").disabled = false;

func use(player):
	#get_node("collision").disabled = true;
	#player.move = false;
	#var _title = get_parent().get_parent().get_node("title");
	#var _subtitle = get_parent().get_parent().get_node("subtitle");
	get_parent().get_parent().objects.chillzone.use(player);
#		player.object.queue_free();
#		player.object = null;
#		get_node("audio").play();
#		get_node("model").get_active_material(0).albedo_texture = texture;
#		var camera = player.camera;
#		var _translation = camera.global_translation;
#		var _rotation = camera.global_rotation;
#		player.remove_child(camera);
#		get_parent().get_parent().add_child(camera);
#		camera.global_translation = _translation;
#		camera.global_rotation = _rotation;
#		var tween = get_tree().create_tween();
#		tween.parallel().tween_property(camera, "translation", Vector3(12.255, 3.8, -6.3), 1.5).set_trans(Tween.TRANS_SINE);
#		tween.parallel().tween_property(camera, "rotation_degrees", Vector3(0, 48, 0), 1.5).set_trans(Tween.TRANS_SINE);
#		tween.parallel().tween_property(camera, "fov", 30.0, 1.5).set_trans(Tween.TRANS_SINE);
#		#tween.tween_property(get_parent().get_parent().get_node("curtain"), "color", Color(0, 0, 0, 1), 0.5);
#		yield(get_tree().create_timer(1.5), "timeout");
#		get_parent().get_parent().state = 3;
