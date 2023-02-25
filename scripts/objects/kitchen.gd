extends StaticBody;

var type: String = "take";
var state: int = 0;

func _ready():
	get_node("animation").connect("animation_finished", self, "_animation_finished");

func take(player: KinematicBody):
	get_node("collision").disabled = true;
	get_node("animation").play("open");
	if not get_parent().get_parent().get_node("club/kitchen/chief").visible:
		get_parent().get_parent().get_node("backstreet").visible = true;
		get_parent().get_parent().get_node("club/kitchen").show();
	state = 1;

func _process(delta):
	if state == 1 and translation.distance_squared_to(get_parent().get_parent().player.translation) > 4:
		get_node("collision").disabled = false;
		get_node("animation").play_backwards("open");
		state = 0;

func _animation_finished(name):
	if state == 0:
		if Vector3(26.5, 0.15, -7).distance_squared_to(get_parent().get_parent().player.translation) > 9:
			get_parent().get_parent().get_node("backstreet").visible = false;
			get_parent().get_parent().get_node("club/kitchen").hide();

func use(player):
	player.object.drop();
