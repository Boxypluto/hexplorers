extends RigidBody3D

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	angular_velocity = global_transform.basis.y * Vector3(0, 1.0, 0)
