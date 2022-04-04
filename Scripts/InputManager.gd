extends Node

func _ready():
	pass # Replace with function body.

signal move_player(position)
signal move_enemy(position)
signal stop_move

var nodePos = Vector2(0, 0)

func node_tapped(position):
	#print("node pressed:")
	#print(position)
	nodePos = position
	emit_signal("move_player", position)
	pass

func node_released():
	#print("node released")
	emit_signal("stop_move")
	pass

func node_destroyed(position):
	#print("node destroyed")
	if nodePos == position:
		emit_signal("stop_move")
