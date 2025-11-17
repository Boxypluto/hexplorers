extends CharacterBody2D
class_name Player

@onready var animations: AnimatedSprite2D = $Animations
@onready var weapon_machine: WeaponStateMachine = $WeaponStates
@onready var duability_indicator: DurabilityIndicator = $"../HUD/Control/DuabilityIndicator"

# flytimer controls the time between each flap
# stamina controls how many flaps until out
# staminaRegen is a control timer to regen stamina
# invenotry is a string list, can create weapons from there
var flytimer = 0
var staminaRegen = 0
var health = 100
var hitTimer = 0

var max_speed: float = 10.0
var acceleration: float = 5.0 * 180.0
var gravity: float = 500
var fast_gravity: float = 1200
var max_fall_speed: float = 250.0
var max_fast_fall_speed: float = 500.0
var max_rise_speed: float = 250.0

var just_picked_up_weapon: bool = false

const PICKUP_DISTANCE: float = 64.0

func _physics_process(delta: float) -> void:
	
	pickupable_process()
	health_process()
	walk_process(delta)
	gravity_process(delta)
	
	# constant velocity: velocity.x is smoothed towards zero, velocity.y is gravity
	
	
	
	if Input.is_action_pressed("Fly") and ((flytimer <= 0) or (is_on_floor())):
		flytimer = 0.5
		velocity.y -= 350
		staminaRegen = 2
		animations.play("flap")
	
	# Timer control, regen and time between each flap
	if flytimer > 0:
		flytimer -= delta
	
	if Input.is_action_just_pressed("Attack") and not just_picked_up_weapon:
		weapon_machine.do_action()
	if hitTimer > 0:
		hitTimer -= delta
		modulate= Color.html("#ffaaaa")
	else:
		modulate= Color.html("#ffffff")
	
	# Animate the player (below)
	animate()
	move_and_slide()
	reset_perframe_variables()

func reset_perframe_variables():
	just_picked_up_weapon = false

func walk_process(delta: float):
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, 1.0 / 15.0)
	else:
		velocity.x = lerp(velocity.x, 0.0, 1.0 / 50.0)
	velocity.x = clamp(velocity.x, -150, 150)
	if Input.is_action_pressed("Right"):
		print(1.0 / delta)
		velocity.x += acceleration * delta
	if Input.is_action_pressed("Left"):
		velocity.x -= acceleration * delta

func gravity_process(delta: float):
	var current_max_fall: float = max_fall_speed
	var current_gravity: float = gravity
	if Input.is_action_pressed("Down"):
		current_max_fall = max_fast_fall_speed
		current_gravity = fast_gravity
	velocity.y += current_gravity * delta
	velocity.y = clamp(velocity.y, -max_rise_speed, current_max_fall)

func health_process():
	if health < 0 or global_position.y > 700:
		get_parent().get_node("deathCam").zoom = $Camera2D.zoom
		get_parent().get_node("deathCam").global_position = $Camera2D.global_position
		get_parent().get_node("deathCam").enabled = true
		queue_free()
	elif health>100:
		health = 100

func animate():
	# Save horizontal input
	var horizontal_input: float = Input.get_axis("Left", "Right")
	
	# Always play animations (for now)
	if not animations.is_playing() and animations.animation != "flap":
		animations.play()
		
	# Flip the sprite based on movement
	if sign(horizontal_input) == 1:
		animations.flip_h = false
	if sign(horizontal_input) == -1:
		animations.flip_h = true
		
	# Idle if there's NO INPUT or if the player is NOT ON FLOOR
	# *This will change later*, when I make more animations
	if is_on_floor():
		if horizontal_input == 0.0:
			animations.animation = "idle"
		else:
			animations.animation = "walk"
	else:
		if not (animations.animation == "flap" and animations.is_playing()):
			if velocity.y < 0:
				animations.animation = "jump"
			else:
				animations.animation = "fall"
			
func damage(force: Vector2, h: int):
	velocity.x += force.x
	velocity.y -= 8
	if hitTimer < 0.24:
		health -= h
	hitTimer = 0.25

func pickupable_process() -> void:
	var closest: PickupableWeapon = null
	var closest_distance: float = INF
	for pickupable in Registry.pickupables:
		if is_instance_valid(pickupable):
			pickupable.highlighted = false
			var distance: float = pickupable.global_position.distance_to(global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest = pickupable
	if closest:
		if closest_distance > PICKUP_DISTANCE:
			closest = null
		else:
			closest.highlighted = true
	
	if Input.is_action_just_pressed("PickUp") and closest != null and (weapon_machine.current_state == null or closest.id != weapon_machine.current_state.id()):
		weapon_machine.swap_to_id(closest.do_pickup(), closest.custom_data)
		print("PICKED UP")
		just_picked_up_weapon = true
