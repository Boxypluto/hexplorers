extends RigidBody3D

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	angular_velocity = global_transform.basis * Vector3(0, 0.4, 0)
