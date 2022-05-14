extends KinematicBody2D

#Move toward player slowly
#Function as node for player movement
#Die when touching a wall

onready var input = get_tree().get_root().get_node("Game/InputManager")
onready var spawner = get_parent()
onready var collision = $CollisionShape2D
#onready var player = get_tree().get_root().get_node("Game/CurrentScene/Main/Player")
onready var player = spawner.get_parent().get_node("Player")
onready var stunTimer = $StunTimer
#onready var collisionTimer = $CollisionTimer

signal tapped(position, multiplier)
signal released
signal destroyed(position)
signal gainPoints(amount)

var velocity = Vector2(0, 0)
export var speed = 400
export var acceleration = 0.5
export var friction = 0.1

export var points = 1
export var health = 1

var nodePosition = Vector2(0, 0)
#var spawned = true
var tapped = false
var stunned = false

func _ready():
	#collision.disabled = true
	#collisionTimer.start()
	set_meta("type", "enemy")
	connect("tapped", input, "node_tapped")
	connect("released", input, "node_released")
	connect("destroyed", input, "node_destroyed")
	connect("gainPoints", spawner, "gainPoints")
	pass # Replace with function body.
	
func spawn():
	#When spawned, the enemy will be just offscreen
	#Turn off collision while the enemy enters the game
	pass
	
func die():
	if tapped == true or stunned == true:
		emit_signal("gainPoints", points)
	tapped = false
	emit_signal("destroyed", nodePosition)
	queue_free()

func _on_TouchScreenButton_pressed():
	nodePosition = global_position
	tapped = true
	stunned = true
	emit_signal("tapped", global_position, 1.2)
	pass

func _on_TouchScreenButton_released():
	nodePosition = Vector2(0, 0)
	tapped = false
	stunTimer.start()
	emit_signal("released")
	pass

func _physics_process(delta):
	#if spawned == true:
		#velocity = global_position.direction_to(player.global_position)
		#velocity.x = lerp(velocity.x, velocity.x * speed, acceleration * 2)
		#velocity.y = 0
	if tapped == false && stunned == false:
		#Move toward player
		if player != null:
			velocity = global_position.direction_to(player.global_position)
		velocity.x = lerp(velocity.x, velocity.x * speed, acceleration)
		velocity.y = lerp(velocity.y, velocity.y * speed, acceleration)
		pass
	elif tapped == true:
		#Function as a node, but moves with physics
		velocity = global_position.direction_to(player.global_position)
		if player.global_position.y < global_position.y:
			velocity *= -1
			velocity.x = lerp(velocity.x, velocity.x * (speed * 3), acceleration)
			velocity.y = lerp(velocity.y, velocity.y * (speed * 3), acceleration)
		else:
			velocity.x = lerp(velocity.x, velocity.x * (speed), acceleration)
			velocity.y = lerp(velocity.y, velocity.y * (speed), acceleration)
		pass
	elif stunned == true:
		#Don't move
		pass
		
	var collision = move_and_collide(velocity * delta, false)
	if collision:
		var type = collision.collider.get_meta("type")
		if type == "wall":
			#if global_position.x <= 150 or global_position.x >= 890:
				#pass
			#else:
				#print("wall")
			die()

func _on_Timer_timeout():
	stunned = false
