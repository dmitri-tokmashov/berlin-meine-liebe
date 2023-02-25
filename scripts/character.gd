extends Node;

func initialize(type, animation, model):
	if type == "slon":
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
	elif type == "chief":
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
	elif type == "man_0":
		var _body: Material = model.get_node("Skeleton/survivor_gambler_reference").get_active_material(0).duplicate();
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
		if animation == "dancing":
			_body.albedo_color = Color8(0, 192, 224);
			model.get_node("Skeleton/survivor_gambler_reference").set_surface_material(0, _body);
		elif animation == "drunk":
			model.get_node("AnimationPlayer").playback_speed = 0.75;
	elif type == "man_1":
		#var _body: Material = model.get_node("Skeleton/survivor_gambler_reference").get_active_material(0).duplicate();
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
		#if animation == "dancing":
			#_body.albedo_color = Color8(0, 192, 224);
			#model.get_node("Skeleton/survivor_gambler_reference").set_surface_material(0, _body);
		#elif animation == "drunk":
			#model.get_node("AnimationPlayer").playback_speed = 0.75;
	elif type == "man_2":
		#var _body: Material = model.get_node("Skeleton/survivor_gambler_reference").get_active_material(0).duplicate();
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
	elif type == "woman_0":
		var _hair: Material = model.get_node("Skeleton/Hairs_Plano004").get_active_material(0).duplicate();
		var _head: Material = model.get_node("Skeleton/Hairbase_3003").get_active_material(0).duplicate();
		var _shirt: Material = model.get_node("Skeleton/FinalShirt_Plano013").get_active_material(0).duplicate();
		var _pants: Material = model.get_node("Skeleton/Pants_Plano017").get_active_material(0).duplicate();
		var _boots: Material = model.get_node("Skeleton/Boots_Cubo009").get_active_material(0).duplicate();
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
		if animation == "bartending":
			model.get_node("Skeleton/Belt_Plano019").visible = false;
			_shirt.albedo_color = Color8(240, 32, 96);
			model.get_node("Skeleton/FinalShirt_Plano013").set_surface_material(0, _shirt);
		elif animation == "dancing":
			model.get_node("Skeleton/Belt_Plano019").visible = false;
			_hair.albedo_color = Color8(240, 96, 0);
			_head.albedo_color = Color8(240, 96, 0);
			_shirt.albedo_color = Color8(96, 0, 192);
			_pants.albedo_color = Color8(192, 16, 16);
			model.get_node("Skeleton/Hairs_Plano004").set_surface_material(0, _hair);
			model.get_node("Skeleton/Hairbase_3003").set_surface_material(0, _head);
			model.get_node("Skeleton/Pants_Plano017").set_surface_material(0, _pants);
			model.get_node("Skeleton/FinalShirt_Plano013").set_surface_material(0, _shirt);
		elif animation == "drinking":
			model.get_node("Skeleton/Belt_Plano019").visible = false;
			_hair.albedo_color = Color8(240, 96, 0);
			_head.albedo_color = Color8(240, 96, 0);
			_shirt.albedo_color = Color8(192, 16, 16);
			_boots.albedo_color = Color8(192, 16, 16);
			model.get_node("Skeleton/Hairs_Plano004").set_surface_material(0, _hair);
			model.get_node("Skeleton/Hairbase_3003").set_surface_material(0, _head);
			model.get_node("Skeleton/FinalShirt_Plano013").set_surface_material(0, _shirt);
			model.get_node("Skeleton/Boots_Cubo009").set_surface_material(0, _shirt);
	elif type == "woman_1":
		#var _body: Material = model.get_node("Skeleton/survivor_gambler_reference").get_active_material(0).duplicate();
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
		if animation == "dancing_1":
			model.get_node("AnimationPlayer").playback_speed = 0.75;
	elif type == "woman_2":
		#var _body: Material = model.get_node("Skeleton/survivor_gambler_reference").get_active_material(0).duplicate();
		model.get_node("AnimationPlayer").get_animation("default").loop = true;
		model.get_node("AnimationPlayer").play("default");
