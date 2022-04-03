extends Node

#Spawn coins based on "intensity" value
#Higher intensity means more chance of multiple coins spawning in a cluster

onready var gameData = get_parent()
var rng = RandomNumberGenerator.new()

var coinObject = preload("res://Objects/Coin.tscn")

var prevHeight = 0
var probability = 20 #The probability of spawning 2 coins; the chance of spawning 3 coins is half

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass

func spawnCoin(height):
	#Pick one or more locations between 200 and 900 to spawn coins
	#Todo: coin formations as objects?
	var rand
	var spawn
	
	rand = rng.randi_range(200, 900)
	spawn = coinObject.instance()
	add_child(spawn)
	spawn.position = (Vector2(rand, height + 100))
	pass
