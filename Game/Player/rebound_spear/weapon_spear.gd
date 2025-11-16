extends WeaponStateGenericThrow

var starting_durability: int = 3

func pre_position(projectile: Node2D):
	assert(projectile is ProjectileReboundSpear)
	if projectile is ProjectileReboundSpear:
		var durability: int = custom_data.get(&"durability", starting_durability)
		projectile.durability = durability

func get_durability() -> int:
	return custom_data.get(&"durability", starting_durability)
