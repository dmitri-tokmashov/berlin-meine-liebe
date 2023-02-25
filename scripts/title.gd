extends Label;

func say(string, time):
	text = string;
	modulate.a = 0;
	var tween = get_tree().create_tween();
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 1), 0.125);
	yield(get_tree().create_timer(time - 0.125), "timeout");
	tween = get_tree().create_tween();
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), 0.125);
	
