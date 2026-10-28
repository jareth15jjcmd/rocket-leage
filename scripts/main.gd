extends Node3D

const CAR_SCRIPT = preload("res://scripts/car_controller.gd")
const BALL_SCRIPT = preload("res://scripts/ball.gd")

var car: RigidBody3D
var ball: RigidBody3D
var score_blue := 0
var score_orange := 0
var time_left := 180.0
var hud: Label
var camera: Camera3D
var goal_lock := 0.0

func _ready() -> void:
	_build_arena()
	_spawn_car()
	_spawn_ball()
	_build_camera()
	_build_hud()

func _process(delta: float) -> void:
	time_left = maxf(0.0, time_left - delta)
	goal_lock = maxf(0.0, goal_lock - delta)
	if is_instance_valid(camera) and is_instance_valid(car):
		var target := car.global_position + Vector3(0, 2.0, 0)
		var behind := car.global_position + car.global_transform.basis.z * 9.0 + Vector3.UP * 5.0
		camera.global_position = camera.global_position.lerp(behind, minf(1.0, delta * 4.0))
		camera.look_at(target, Vector3.UP)
	if is_instance_valid(hud):
		hud.text = "TURBO ARENA     BLUE %d - %d ORANGE     TIME %02d:%02d\nWASD / ARROWS: DRIVE     SPACE: JUMP     SHIFT: BOOST" % [score_blue, score_orange, int(time_left) / 60, int(time_left) % 60]
	_check_goals()

func _build_arena() -> void:
	_add_box("Floor", Vector3(0, -0.6, 0), Vector3(34, 1.2, 54), Color(0.08, 0.24, 0.25))
	_add_box("LeftWall", Vector3(-17, 2.0, 0), Vector3(1, 5, 54), Color(0.12, 0.18, 0.23))
	_add_box("RightWall", Vector3(17, 2.0, 0), Vector3(1, 5, 54), Color(0.12, 0.18, 0.23))
	_add_box("BlueEndWall", Vector3(0, 2.0, -27), Vector3(34, 5, 1), Color(0.08, 0.25, 0.65))
	_add_box("OrangeEndWall", Vector3(0, 2.0, 27), Vector3(34, 5, 1), Color(0.75, 0.24, 0.06))
	_add_box("CenterStripe", Vector3(0, 0.02, 0), Vector3(0.18, 0.04, 54), Color(0.8, 0.9, 0.9), false)

func _add_box(label: String, pos: Vector3, size: Vector3, color: Color, solid: bool = true) -> void:
	var body := StaticBody3D.new()
	body.name = label
	body.position = pos
	add_child(body)
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.8
	mesh.material_override = mat
	body.add_child(mesh)
	if solid:
		var shape := CollisionShape3D.new()
		var box_shape := BoxShape3D.new()
		box_shape.size = size
		shape.shape = box_shape
		body.add_child(shape)

func _spawn_car() -> void:
	car = RigidBody3D.new()
	car.name = "PlayerCar"
	car.position = Vector3(0, 1.1, 9)
	car.mass = 1.4
	car.linear_damp = 0.35
	car.angular_damp = 3.0
	car.continuous_cd = true
	car.set_script(CAR_SCRIPT)
	add_child(car)
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.8, 0.65, 2.8)
	mesh.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.1, 0.55, 1.0)
	mat.metallic = 0.25
	mat.roughness = 0.3
	mesh.material_override = mat
	car.add_child(mesh)
	var shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = Vector3(1.8, 0.65, 2.8)
	shape.shape = box_shape
	car.add_child(shape)

func _spawn_ball() -> void:
	ball = RigidBody3D.new()
	ball.name = "SoccerBall"
	ball.position = Vector3(0, 1.6, 0)
	ball.mass = 0.8
	ball.linear_damp = 0.12
	ball.angular_damp = 0.08
	ball.continuous_cd = true
	ball.set_script(BALL_SCRIPT)
	add_child(ball)
	var mesh := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	sphere_mesh.radius = 1.25
	sphere_mesh.height = 2.5
	mesh.mesh = sphere_mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.95, 0.97, 1.0)
	mat.roughness = 0.35
	mesh.material_override = mat
	ball.add_child(mesh)
	var shape := CollisionShape3D.new()
	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = 1.25
	shape.shape = sphere_shape
	ball.add_child(shape)

func _build_camera() -> void:
	camera = Camera3D.new()
	camera.name = "ChaseCamera"
	camera.position = Vector3(0, 6, 18)
	camera.fov = 78
	add_child(camera)
	camera.current = true

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(20, 18)
	hud.add_theme_font_size_override("font_size", 20)
	hud.add_theme_color_override("font_color", Color.WHITE)
	layer.add_child(hud)

func _check_goals() -> void:
	if goal_lock > 0.0 or not is_instance_valid(ball):
		return
	if ball.global_position.z < -25.5 and absf(ball.global_position.x) < 5.0 and ball.global_position.y < 4.0:
		score_orange += 1
		_reset_kickoff()
	elif ball.global_position.z > 25.5 and absf(ball.global_position.x) < 5.0 and ball.global_position.y < 4.0:
		score_blue += 1
		_reset_kickoff()

func _reset_kickoff() -> void:
	goal_lock = 1.5
	ball.linear_velocity = Vector3.ZERO
	ball.angular_velocity = Vector3.ZERO
	ball.global_position = Vector3(0, 1.6, 0)
	car.linear_velocity = Vector3.ZERO
	car.angular_velocity = Vector3.ZERO
	car.global_position = Vector3(0, 1.1, 9)
	car.global_rotation = Vector3.ZERO
