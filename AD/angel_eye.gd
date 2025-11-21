extends CSGCombiner3D

@onready var blood: GPUParticles3D = $GPUParticles3D

func _physics_process(delta: float) -> void:
	blood.global_rotation = Vector3.ZERO
