extends Node

func frame(time: float = 0.05):
	Engine.time_scale = 0.0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1.0
