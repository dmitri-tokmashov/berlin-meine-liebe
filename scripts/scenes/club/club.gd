extends Node;

onready var lights = [get_node("light_1"), get_node("light_2")];
onready var characters = [get_node("front/woman"), get_node("dancer_1"), get_node("dancer_2"), get_node("dancer_3"), get_node("dancer_4"), get_node("dancer_5"), get_node("dancer_6"), get_node("dancer_7"), get_node("drunk"), get_node("man_1"), get_node("man_2"), get_node("man_3"), get_node("woman_1"), get_node("woman_2"), get_node("upstairs/man"), get_node("upstairs/woman")];

func _ready():
	character.initialize("woman_0", "drinking", characters[0]);
	character.initialize("woman_0", "dancing", characters[1]);
	character.initialize("man_0", "dancing", characters[2]);
	character.initialize("man_1", "dancing", characters[3]);
	character.initialize("man_2", "dancing_1", characters[4]);
	character.initialize("man_2", "dancing_2", characters[5]);
	character.initialize("woman_1", "dancing_1", characters[6]);
	character.initialize("woman_1", "dancing_2", characters[7]);
	character.initialize("man_0", "drunk", characters[8]);
	character.initialize("man_1", "sitting", characters[9]);
	character.initialize("man_2", "sitting", characters[10]);
	character.initialize("man_0", "sitting", characters[11]);
	character.initialize("woman_2", "sitting", characters[12]);
	character.initialize("woman_1", "laying", characters[13]);
	character.initialize("man_2", "sitting", characters[14]);
	character.initialize("woman_0", "talking", characters[15]);

func _process(delta):
	for index in lights.size():
		lights[index].rotation.y = deg2rad([-45, -135, 135][index] + sin(fmod(OS.get_ticks_msec(), 8000) / 4000 * PI) * [-40, -15, -20][index]);

func delete_characters_inside():
	for character in characters:
		character.queue_free();
