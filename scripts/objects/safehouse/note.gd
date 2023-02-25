extends RigidBody;

var taken: bool = false;
var type: String = "take";

func _physics_process(delta):
		if taken:
			global_translation += (get_parent().to_global(Vector3(0, 0.7, -0.05)) - global_translation) * 4 * delta;
			global_rotation += (get_parent().global_rotation + Vector3(deg2rad(-30), 0, 0) - global_rotation) * 4 * delta;

func take(player: KinematicBody):
	get_parent().get_parent().note = true;
	get_node("collision").disabled = true;
	taken = true;
	var _position = global_translation;
	var _rotation = global_rotation;
	get_parent().remove_child(self);
	player.add_child(self);
	player.object = self;
	global_translation = _position;
	global_rotation = _rotation;

func use(player: KinematicBody):
	take(player);

func drop():
	mode = RigidBody.MODE_RIGID;
	add_central_force(Vector3(0, 64, -192).rotated(Vector3.UP, get_parent().rotation.y));
	get_node("collision").disabled = false;
	taken = false;
	var _position = global_translation;
	var _rotation = global_rotation;
	var _parent = get_parent().get_parent().get_node("objects");
	get_parent().object = null;
	get_parent().remove_child(self);
	_parent.add_child(self);
	global_translation = _position;
	global_rotation = _rotation;
