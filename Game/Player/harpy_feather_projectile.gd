extends CharacterBody2D
class_name ProjectilePlayerFeather

@onready var damage_shape: CollisionShape2D = $DamageDealer/DamageShape
@onready var damage_timer: Timer = $DamageDealer/DamageTimer
@onready var harpy_feather_thrown: Spin = $HarpyFeatherThrown
const BREAK_EFFECT = preload("res://Game/Player/rebound_spear/rebound_spear_break_effect.tscn")

var direction: Vector2
const SPEED: float = 470.0
var hit_slowdown_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(hit_slowdown_timer)
	hit_slowdown_timer.wait_time = 0.1
	hit_slowdown_timer.one_shot = true

func setup(initial_direction: Vector2):
	direction = initial_direction

func _physics_process(delta: float) -> void:
	var multiplier: float = 1.0
	if not hit_slowdown_timer.is_stopped():
		multiplier = 0.2
	harpy_feather_thrown.multiplier = multiplier
	velocity = direction * SPEED * delta * multiplier
	var _collision: KinematicCollision2D = move_and_collide(velocity)

func do_break():
	var effect: GPUParticles2D = BREAK_EFFECT.instantiate()
	get_parent().add_child(effect)
	effect.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	effect.global_position = global_position
	effect.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
	queue_free()

func damage_cycle() -> void:
	damage_shape.disabled = true
	await get_tree().create_timer(damage_timer.wait_time / 4.0).timeout
	damage_shape.disabled = false

func did_hit_thing() -> void:
	hit_slowdown_timer.start()
