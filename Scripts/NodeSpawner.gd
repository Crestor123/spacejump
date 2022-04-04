extends Node

onready var gameData = get_parent()
var rng = RandomNumberGenerator.new()

var nodeObject = preload("res://Objects/Node.tscn")
var prevHeight = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func spawnNode(height):
	#Pick one or more random positions between 200 and 900 and spawn nodes
	var flag = false
	var rand = 0
	var spawncount = 1
	var spawned = 0
	var probability = 38
	if prevHeight == height:
		print("do not spawn")
		return
	prevHeight = height
	
	#Spawn two nodes at once sometimes, inversely related to intensity
	probability = probability - (gameData.intensity * 2)
	rand = rng.randi_range(1, 100)
	if rand < probability: spawncount = 2
	print("spawncount: ", spawncount)
	
	for i in spawncount:
		flag = true
		while flag == true:
			flag = false
			rng.randomize()
			rand = rng.randi_range(200, 900)
			for child in self.get_children():
				if abs(child.global_position.y - (height - 125)) <= 20:
				#if spawned > 0:
					#print("Y: ", child.global_position.y, " ", height - 125)
					#print("X: ", child.global_position.x, " ", rand)
					if abs(child.global_position.x - rand) <= 250:
				#if abs(child.global_position.x - rand) <= 200 && child.global_position.y == (height - 125):
						#print("canceled spawn: ", abs(child.global_position.x - rand))
						flag = true
		spawned = spawned + 1
		var spawn = nodeObject.instance()
		add_child(spawn)
		#print("Spawning node: ", height - 125, " ", rand)
		spawn.position = (Vector2(rand, height - 125))
	pass
