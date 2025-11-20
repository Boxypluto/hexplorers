extends Sprite2D

@onready var pupil: Sprite2D = $Pupil

var direction: Vector2
var dist: float
var player: Player
var dist_goal: float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if not is_instance_valid(player): return
	direction = player.global_position.direction_to(global_position)
	dist = 500.0
	dist_goal = 500.0
	
	await get_tree().create_timer(5.0).timeout
	
	flip_eye()

func flip_eye(_a = null):
	print("TURN")
	dist_goal = -32.0

func _process(delta: float) -> void:
	if not is_instance_valid(player): return
	print(dist)
	direction = player.global_position.direction_to(global_position)
	pupil.position = direction * dist * (player.global_position.distance_to(global_position) / 300.0)
	dist = lerpf(dist, dist_goal, 1.0 - ((1.0 - 0.99) ** delta))
