extends RigidBody2D
func _process(_delta: float) -> void:
	if GlobalVariables.currentLevel.has_node("Player"):
		var distanceTowardPlayer = global_position.distance_to(GlobalVariables.currentLevel.get_node("Player").global_position);
		modulate.v = 0.5;
		if distanceTowardPlayer < 50:
			if GlobalVariables.firstSelected != self:
				if GlobalVariables.firstSelected == null or GlobalVariables.firstSelected.global_position.distance_to(GlobalVariables.currentLevel.get_node("Player").global_position) >distanceTowardPlayer:
					GlobalVariables.firstSelected = self;
			if GlobalVariables.firstSelected == self:
				modulate.v = 1.1;
				if Input.is_action_just_pressed("PickUp"):
					GlobalVariables.currentLevel.get_node("Player").inventory.append("Bone");
					queue_free();
					GlobalVariables.firstSelected = null;
