extends CanvasLayer

func _process(delta: float) -> void:
	if get_parent().has_node("Player"):
		$Health/Current.size.x += ((229.0*(get_parent().get_node("Player").health/100.0))-$Health/Current.size.x)/15.0;
		$Stamina/Current.size.x += ((151.0*(get_parent().get_node("Player").stamina/8.0))-$Stamina/Current.size.x)/15.0;
	else:
		$Health/Current.size.x += (0-$Health/Current.size.x)/15.0;
		$Stamina/Current.size.x += (0-$Stamina/Current.size.x)/15.0;
