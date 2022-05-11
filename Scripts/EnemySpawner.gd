extends Node

onready var gameData = get_parent()
onready var timer = $Timer
var rng = RandomNumberGenerator.new()

var enemyObject = preload("res://Objects/Enemy.tscn")

var probability = 20

func _ready():
	rng.randomize()
	timer.start()
	pass

func spawnEnemy():
	print("spawning enemy ?")
	#Spawn rate is based on intensity
	#The spawn position should be either x = 1100 or -20, y random based on maxheight
	
	var rand
	var spawn
	
	rand = rng.randi_range(1, 100)
	if rand < probability + (gameData.intensity * 2):
		print("spawning enemy")
		#spawn an enemy
		spawn = enemyObject.instance()
		add_child(spawn)
		rand = rng.randi_range(0, 1)
		if rand == 0:
			#spawn left
			spawn.position = Vector2(-20, (gameData.nodeHeight * 100) + 1000)
		if rand == 1:
			#spawn right
			spawn.position = Vector2(1100, (gameData.nodeHeight * 100) + 1000)
		print(spawn.position)
	pass

func _on_Timer_timeout():
	if gameData.playerMaxHeight < -11770:
		spawnEnemy()
	#else:
	timer.start()
	pass
