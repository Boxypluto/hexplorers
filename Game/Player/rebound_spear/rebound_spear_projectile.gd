extends CharacterBody2D
class_name ProjectileReboundSpear

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $SolidCollision
@onready var damage_dealer: DamageDealer = $DamageDealer
@onready var pick_up: Sprite2D = $PickUp
@onready var pickupable_weapon: PickupableWeapon = $PickupableWeapon
@onready var rebound_shape: CollisionShape2D = $DamageDealer/ReboundShape

var direction: Vector2
var speed: float = 960.0
var state: STATE = STATE.THROW
var durability: int = 3

var rebound_upwards: float = 480.0
var rebound_horizontal: float = 100.0
var rebound_gravity: float = 560.0

enum STATE {
	THROW,
	WAIT,
	REBOUND,
}

func _ready() -> void:
	pick_up.visible = false
	pickupable_weapon.custom_data[&"durability"] = durability - 1
	rebound_shape.disabled = true

func _physics_process(delta: float) -> void:
	match state:
		STATE.THROW:
			velocity.x = direction.x * speed
		STATE.REBOUND:
			velocity.y += rebound_gravity * delta
			sprite.rotation -= delta * 16.0
	
	var move_collison: KinematicCollision2D = move_and_collide(velocity * delta)
	if move_collison != null:
		destroy()

func do_rebound() -> void:
	state = STATE.WAIT
	await get_tree().create_timer(0.02, false, true).timeout
	if durability <= 0:
		destroy()
		return
	collision.disabled = true
	pick_up.visible = true
	rebound_shape.disabled = false
	state = STATE.REBOUND
	velocity.x = rebound_horizontal * -sign(velocity.x)
	velocity.y = -rebound_upwards
	sprite.play("Rebound")

func destroy() -> void:
	queue_free()

func on_dealt_damage() -> void:
	if state == STATE.THROW:
		do_rebound()

func on_picked_up() -> void:
	queue_free()
