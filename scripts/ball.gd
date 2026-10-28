extends RigidBody3D
class_name ArenaBall

@export var hit_impulse: float = 10.0

func _ready() -> void:
	mass = 0.8
	linear_damp = 0.12
	angular_damp = 0.08
	continuous_cd = true
	can_sleep = false

func kick(direction: Vector3, strength: float = 1.0) -> void:
	if direction.length_squared() > 0.001:
		apply_central_impulse(direction.normalized() * hit_impulse * strength)
