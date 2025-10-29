extends CharacterBody2D

var health = 50;
var active = false;

func _process(delta: float) -> void:
	velocity.x += (0.0-velocity.x)/(15.0);
	velocity.y += 500*delta;
	if global_position.y > 700:
		queue_free();
	if abs(velocity.y) > 250:
		velocity.y = 250*(velocity.y/abs(velocity.y));
	if GlobalVariables.currentLevel.has_node("Player"):
		var target= to_local(GlobalVariables.currentLevel.get_node("Player").global_position);
		if target.length() > 300:
			target = target.normalized() * 300
		$RayCast2D.target_position = target;
		$RayCast2D.force_raycast_update();
		if $RayCast2D.get_collider() == GlobalVariables.currentLevel.get_node("Player"):
			active = true;
		else:
			active = false;
	else:
		active = false;
	if active:
		if abs(velocity.x) < 20 and is_on_floor():
			velocity.y -= 150;
		if GlobalVariables.currentLevel.get_node("Player").global_position.x > global_position.x:
			velocity.x += 4
		elif GlobalVariables.currentLevel.get_node("Player").global_position.x < global_position.x:
			velocity.x += -4;
	else:
		pass
		#IDLE ANIMATION
	move_and_slide();
	if active:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider == GlobalVariables.currentLevel.get_node("Player"):
				var direction = (GlobalVariables.currentLevel.get_node("Player").global_position - global_position).normalized()
				GlobalVariables.currentLevel.get_node("Player").damage(direction * 50, 5)
