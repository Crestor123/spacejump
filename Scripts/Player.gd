extends KinematicBody2D

onready var gameData = get_parent()
onready var input = get_tree().get_root().get_node("Game/InputManager")

signal playerHeight(value)
signal collectCoin
signal playerDead

export var speed = 2000
export var gravity = 30
export var friction = 0.05
export var acceleration = 0.5

var velocity = Vector2(0, 0)
var targetPos = Vector2(0, 0)
var prevPos = Vector2(0, 0)

func set_targetPos(location):
	targetPos = location
	
func unset_targetPos():
	targetPos = Vector2(0, 0)

func die():
	emit_signal("playerDead")
	set_physics_process(false)

func _ready():
	input.connect("move_player", self, "set_targetPos")
	input.connect("stop_move", self, "unset_targetPos")
	connect("playerHeight", gameData, "playerHeightChanged")
	connect("initalHeight", gameData, "setinitalHeight")
	connect("collectCoin", gameData, "collectCoin")
	connect("playerDead", gameData, "playerDead")

func _physics_process(delta):
	if targetPos != Vector2(0, 0):
		velocity = global_position.direction_to(targetPos)
		if global_position.y < targetPos.y:
			velocity *= -1
		velocity.x = lerp(velocity.x, velocity.x * speed, acceleration)
		velocity.y = lerp(velocity.y, velocity.y * speed, acceleration)
		#velocity *= speed
		#print(velocity)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)
	if prevPos != global_position:
		emit_signal("playerHeight", global_position.y)
	prevPos = global_position
	velocity.y = velocity.y + (gravity)
	var collision = move_and_collide(velocity * delta, false)
	if collision:
		var type = collision.collider.get_meta("type")
		if (type == "wall"):
			velocity = velocity.bounce(collision.normal)
		if (type == "coin"):
			collision.collider.die()
			emit_signal("collectCoin")
		else:
			velocity = Vector2(0, 0)
	pass
