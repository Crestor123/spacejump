extends KinematicBody2D

onready var gameData = get_parent()
onready var input = get_tree().get_root().get_node("Game/InputManager")
onready var invulnTimer = $InvulnTimer

signal playerHeight(value)
signal collectCoin
signal playerDead
signal playerHealthChanged(value)

export var health = 3
var invulnerable = false

export var multiplier = 1
export var speed = 2000
export var gravity = 30
export var friction = 0.005
export var acceleration = 0.5

var velocity = Vector2(0, 0)
var targetPos = Vector2(0, 0)
var prevPos = Vector2(0, 0)

func set_targetPos(location, multiply = 1):
	multiplier = multiply
	targetPos = location
	
func unset_targetPos():
	multiplier = 1
	targetPos = Vector2(0, 0)

func damage():
	if invulnerable == false:
		print(health)
		health = health - 1
		emit_signal("playerHealthChanged", -1)
		if health <= 0:
			die()
		invulnerable = true
		invulnTimer.start()
	

func die():
	emit_signal("playerDead")
	set_physics_process(false)

func _ready():
	input.connect("move_player", self, "set_targetPos")
	input.connect("stop_move", self, "unset_targetPos")
	connect("playerHeight", gameData, "playerHeightChanged")
	connect("initalHeight", gameData, "setinitalHeight")
	connect("collectCoin", gameData, "collectCoin")
	connect("playerHealthChanged", gameData, "playerHealthChanged")
	connect("playerDead", gameData, "playerDead")

func _physics_process(delta):
	if targetPos != Vector2(0, 0):
		velocity = global_position.direction_to(targetPos)
		if global_position.y < targetPos.y:
			velocity *= -1
		velocity.x = lerp(velocity.x, velocity.x * speed, acceleration * multiplier)
		velocity.y = lerp(velocity.y, velocity.y * speed, acceleration * multiplier)
		#velocity *= speed
		#print(velocity)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)
	if prevPos.y != global_position.y:
		emit_signal("playerHeight", global_position.y)
	prevPos = global_position
	velocity.y = velocity.y + (gravity)
	var collision = move_and_collide(velocity * delta, false)
	if collision:
		var type = collision.collider.get_meta("type")
		if (type == "wall"):
			unset_targetPos()
			velocity = velocity.bounce(collision.normal) / 2
			#velocity = Vector2(0, 0)
		if (type == "coin"):
			collision.collider.die()
			emit_signal("collectCoin")
		if (type == "enemy"):
				damage()
		#else:
			#print("here")
			#velocity = Vector2(0, 0)
	pass

func _on_InvulnTimer_timeout():
	invulnerable = false
	pass 
