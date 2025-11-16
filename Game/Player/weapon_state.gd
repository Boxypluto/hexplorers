@abstract
extends Node2D
class_name WeaponState

@abstract func id() -> StringName

@onready var machine: WeaponStateMachine = get_parent()
var custom_data: Dictionary[StringName, Variant]

func uses_durability() -> bool:
	return true

func get_durability() -> int:
	return 0

func enter():
	pass

func exit():
	pass

func do_action():
	pass

func physics_update(_delta: float):
	pass
