extends GPUParticles2D

func _ready() -> void:
	emitting = true
	await get_tree().create_timer(3.0).timeout
	queue_free()
