extends WeaponState
class_name WeaponStateGenericThrow

@onready var player: CharacterBody2D = $"../.."
@export var PROJECTILE: PackedScene
@export var throw_point: Marker2D
@export var weapon_id: StringName
@export var weapon_uses_durability: bool = false
@export var exit_on_throw: bool = true

func uses_durability() -> bool:
	return weapon_uses_durability

func _ready() -> void:
	visible = false

func id() -> StringName:
	return weapon_id

func enter():
	visible = true

func exit():
	visible = false

func do_action():
	spawn_projectile()

func spawn_projectile():
	var projectile: Node2D = PROJECTILE.instantiate()
	pre_position(projectile)
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	player.get_parent().add_child(projectile)
	projectile.global_position = throw_point.global_position
	projectile.direction = Vector2.LEFT if player.animations.flip_h else Vector2.RIGHT
	pre_interpolate(projectile)
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
	if exit_on_throw:
		machine.current_state = null

func pre_position(_projectile: Node2D):
	pass

func pre_interpolate(_projectile: Node2D):
	pass
