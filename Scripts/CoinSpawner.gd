extends Node

#Spawn coins based on "intensity" value
#Higher intensity means more chance of multiple coins spawning in a cluster

onready var gameData = get_parent()
var rng = RandomNumberGenerator.new()

var coinObject = preload("res://Objects/Coin.tscn")
var prevHeight = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass

