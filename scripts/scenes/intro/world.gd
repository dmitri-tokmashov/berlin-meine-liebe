extends Spatial

onready var _alarm = get_node("room/alarm");
onready var _pistol = get_node("room/jacket/Skeleton/hand/pistol");
#onready var _pistol = get_node("room/jacket/Skeleton/hand/pistol");

func _ready():
	yield(get_tree().create_timer(1.0), "timeout");
	#$room/hands/AnimationPlayer.playback_speed = 0.25;
	#$room/hands/AnimationPlayer.play("throw_Armature_0");
	get_parent().get_node("music/intro").play(2);
	#get_parent().emit_signal("load_level", "autobahn");
	#$music.play(2);
	yield(get_tree().create_timer(4.0), "timeout");
	$holder/animation.playback_speed = 0.5;
	$room/jacket/AnimationPlayer.playback_speed = 0.5;
	$room/jacket/AnimationPlayer.play("default");
	yield(get_tree().create_timer(1.0), "timeout");
	$holder/animation.playback_speed = 0.75;
	$room/jacket/AnimationPlayer.playback_speed = 0.75;
	yield(get_tree().create_timer(0.75), "timeout");
	$room/hands.visible = true;
	$room/hands/AnimationPlayer.playback_speed = 0.775;
	$room/hands/AnimationPlayer.play("throw_Armature_0");
	yield(get_tree().create_timer(1.375), "timeout");
	$room/animation.stop();
	$room.remove_child(_alarm);
	$room/object_1.add_child(_alarm);
	_alarm.translation = Vector3.ZERO;
	var _global_transform = _pistol.global_transform;
	var _transform = _pistol.transform;
	$room/jacket/Skeleton/hand.remove_child(_pistol);
	$room/object_2.add_child(_pistol);
	_pistol.transform = _transform;
	_pistol.translation = Vector3.ZERO;
	$room/object_1.transform =  _global_transform;
	$room/object_2.transform =  _global_transform;
	$room/object_1.sleeping = false;
	$room/object_2.sleeping = false;
	$room/object_1.add_central_force(Vector3(-2, 0.25, -1.5) * 64);
	$room/object_2.add_central_force(Vector3(-1.5, 0.5, -2) * 64);
	yield(get_tree().create_timer(2), "timeout");
	$light.directional_shadow_max_distance = 96;
	yield($holder/animation, "animation_finished");

	get_parent().load_level("autobahn");

	#queue_free();
	#yield(get_tree().create_timer(10.8), "timeout");
	#$light.directional_shadow_max_distance = 64;
