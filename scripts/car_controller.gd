extends RigidBody3D
class_name ArenaCar

@export var acceleration: float = 34.0
@export var reverse_power: float = 18.0
@export var max_speed: float = 29.0
@export var turn_strength: float = 2.5
@export var jump_impulse: float = 8.5
@export var boost_force: float = 48.0
@export var boost_capacity: float = 100.0

var boost_amount: float = 100.0
var jumps_left: int = 2
var input_enabled: bool = true
var _jump_was_down: bool = false

func _ready() -> void:
	mass = 1.4
	linear_damp = 0.35
	angular_damp = 3.0
	continuous_cd = true
	can_sleep = false

func _physics_process(delta: float) -> void:
	if not input_enabled:
		return
	var throttle := Input.get_action_strength("accelerate") - Input.get_action_strength("reverse")
	var steering := Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	var forward := -global_transform.basis.z
	var flat_forward := Vector3(forward.x, 0.0, forward.z).normalized()
	var speed_forward := linear_velocity.dot(flat_forward)
	if throttle > 0.0 and speed_forward < max_speed:
		apply_central_force(flat_forward * acceleration * mass * throttle)
	elif throttle < 0.0:
		apply_central_force(flat_forward * reverse_power * mass * throttle)
	if absf(speed_forward) > 1.2:
		var grip := clampf(absf(speed_forward) / 8.0, 0.25, 1.0)
		apply_torque(Vector3.UP * steering * turn_strength * mass * grip * signf(speed_forward))
	var jump_down := Input.is_action_pressed("jump")
	if jump_down and not _jump_was_down and jumps_left > 0:
		apply_central_impulse(Vector3.UP * jump_impulse * mass)
		jumps_left -= 1
	_jump_was_down = jump_down
	if Input.is_action_pressed("boost") and boost_amount > 0.0:
		apply_central_force(forward * boost_force * mass)
		boost_amount = maxf(0.0, boost_amount - 32.0 * delta)
	else:
		boost_amount = minf(boost_capacity, boost_amount + 17.0 * delta)
	if absf(linear_velocity.y) < 0.15 and global_position.y < 1.3:
		jumps_left = 2
