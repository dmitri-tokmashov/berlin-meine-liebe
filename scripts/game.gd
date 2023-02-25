extends Node

signal load_level(level);

var _level;
var _next_level;
var levels = {
	#"intro": load("res://scenes/intro.scn"),
	#"autobahn": load("res://scenes/road.scn"),
	#"safehouse": load("res://scenes/safehouse.scn")
	#"club": load("res://scenes/club.scn")
};

func _ready():
	connect("load_level", self, "load_level");
	get_node("interface/Button").connect("button_down", self, "load_road");
	#get_node("Button2").connect("button_down", self, "load_road");

func load_road():
	_level = load("res://scenes/road.scn").instance();
	_next_level = preload("res://scenes/safehouse.scn");
	add_child(_level);
	get_node("interface").queue_free();
	#get_node("Button2").queue_free();

func load_level(level):
	_level.queue_free();
	_level = _next_level.instance();
	if level == "autobahn":
		_next_level = preload("res://scenes/safehouse.scn");
	elif level == "safehouse":
		_next_level = preload("res://scenes/club.scn");
	elif level == "club":
		_next_level = preload("res://scenes/final.scn");
	add_child(_level);
