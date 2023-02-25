extends KinematicBody

var move = true;
var jump: float = 0;
var direction: Vector3;
var sensitivity = 0.25;
var action: String;
var icons = {"take": load("res://textures/icons/take.png"), "talk": load("res://textures/icons/talk.png"), "use": load("res://textures/icons/use.png")};
var object: RigidBody = null;
var target: Dictionary;
onready var camera = get_node("camera");

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _process(delta):
	direction = Vector3.ZERO;
	if not $ray.is_colliding():
		$ray.cast_to = Vector3(0, -1.15, 0);
		$ray.force_raycast_update();
		if $ray.is_colliding() and $ray.get_collision_normal().y < 1:
			pass;
		else:
			direction += Vector3.DOWN * 1.75;
		$ray.cast_to = Vector3(0, -0.85, 0);
		if jump > 0:
			jump -= delta * 0.5;
			direction += Vector3.UP * 6 * jump;
			if jump < 0:
				jump = 0;
	else:
		jump = 0;
	if move:
		if Input.is_action_pressed("control_forward"):
			direction += Vector3.FORWARD;
		if Input.is_action_pressed("control_backward"):
			direction += Vector3.BACK;
		if Input.is_action_pressed("control_left"):
			direction += Vector3.LEFT;
		if Input.is_action_pressed("control_right"):
			direction += Vector3.RIGHT;
		if Input.is_action_pressed("control_jump") and $ray.is_colliding() and jump == 0:
			jump = 0.625;
			direction += Vector3.UP * 6 * jump;
			#direction += Vector3.UP * 2;
		#get_parent().get_node("Label").text = str($ray.get_collision_normal());
	direction = direction.rotated(Vector3.UP, rotation.y) * 192 * delta;
	#move_and_slide(direction);
	if not get_node("collision").disabled:
		move_and_collide(direction / 48);
	#get_parent().get_node("Label").text = str(translation) + "\n" + str(jump);

func _input(event):
	if event is InputEventMouseMotion and camera.get_parent() == self:
		rotation.y -= deg2rad(event.relative.x * sensitivity);
		if abs(camera.global_rotation.x - deg2rad(event.relative.y * sensitivity)) < 1.5:
			camera.rotation.x -= deg2rad(event.relative.y * sensitivity)
		else:
			camera.global_rotation.x = sign(camera.global_rotation.x - deg2rad(event.relative.y * sensitivity)) * 1.5;
		#if camera.rotation.z != 0:
			#camera.rotation.z = 0;
