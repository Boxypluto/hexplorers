extends WeaponState
class_name WeaponStateFeather

const HARPY_FEATHER_PROJECTILE = preload("uid://ioxofyqat76o")
@onready var player: CharacterBody2D = $"../.."
@onready var throw_point: Marker2D = $ThrowPoint

func _ready() -> void:
	visible = false

func id() -> StringName:
	return &"Feather"

func enter():
	visible = true

func exit():
	visible = false

func do_action():
	var projectile: ProjectilePlayerFeather = HARPY_FEATHER_PROJECTILE.instantiate()
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	player.get_parent().add_child(projectile)
	projectile.global_position = throw_point.global_position
	projectile.direction = Vector2.LEFT if player.animations.flip_h else Vector2.RIGHT
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
	machine.current_state = null
