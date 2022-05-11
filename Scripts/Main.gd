extends Node2D

onready var data = get_parent()

onready var heightLabel = $UILayer/Height
onready var pointsLabel = $UILayer/Points
onready var nodeSpawner = $NodeSpawner
onready var coinSpawner = $CoinSpawner
onready var killfloor = $Killfloor
onready var leftWall = $LeftWall
onready var rightWall = $RightWall
onready var player = $Player

onready var replayButton = $UILayer/Replay

var points = 0

var playerInitialHeight = 1770
var playerMaxHeight = 0
var playerCurrHeight = 0

var coinFlag = false
var nodeHeight = 0.0
var prevHeight = 0

var intensity = 1

func _ready():
	leftWall.set_meta("type", "wall")
	rightWall.set_meta("type", "wall")
	pointsLabel.text = str(points)
	replayButton.visible = false
	pass 

func _on_Replay_pressed():
	data.reload()

func collectCoin():
	#points = int(points + (95 + pow(0.75, intensity) + (5 * intensity)))
	points += 1
	pointsLabel.text = str(points)
	pass

func playerDead():
	print("Game Over")
	replayButton.visible = true
	
func playerHeightChanged(height):
	#var nodeHeight = 0.0
	playerCurrHeight = height - playerInitialHeight
	if playerMaxHeight > playerCurrHeight:
		playerMaxHeight = playerCurrHeight
		moveKillfloor(height + 1700)
		moveWalls(height)
		nodeHeight = (floor(playerMaxHeight)) / 100
		#print ("node height: ", nodeHeight, " prev height", prevHeight)
		#print("next node: ", prevHeight - (2 * (1 + float(intensity) * 1.075)))
		if nodeHeight <= prevHeight - (2 * (1 + float(intensity) * 1.075)) or nodeHeight <= prevHeight - 10:
			#if nodeHeight <= prevHeight - 10: print("too far")
			prevHeight = nodeHeight
			intensity = int((-1 * (nodeHeight / 100)) + 1)
			#print("intensity: ", intensity)
			#print("node Height: ", nodeHeight)
			spawnNode(nodeHeight * 100)
			if coinFlag == true:
				spawnCoin((nodeHeight * 100))
				coinFlag = false
			elif coinFlag == false:
				#print("here")
				coinFlag = true
	heightLabel.text = str(floor((playerMaxHeight * -1) / 100))
	pass

func spawnNode(height):
	nodeSpawner.spawnNode(height)
	
func spawnCoin(height):
	coinSpawner.spawnCoin(height)
	pass

func moveWalls(height):
	rightWall.global_position.y = height - 350
	leftWall.global_position.y = height - 350
	pass

func moveKillfloor(height):
	killfloor.global_position.y = height - 350
	pass
