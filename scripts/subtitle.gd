extends Label3D;

func say(character, string, time):
	translation = character.global_translation + Vector3(0, 1.75, 0);
	text = string;
	modulate.a = 0;
	var tween = get_tree().create_tween();
	tween.parallel().tween_property(self, "translation", translation + Vector3(0, 0.17, 0), 0.25);
	tween.parallel().tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 1), 0.5);
	yield(get_tree().create_timer(time - 0.25), "timeout");
	tween = get_tree().create_tween();
	tween.parallel().tween_property(self, "translation", translation + Vector3(0, -0.17, 0), 0.25);
	tween.parallel().tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), 0.125);
