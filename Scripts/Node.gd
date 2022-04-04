extends Node2D

onready var input = get_tree().get_root().get_node("Game/InputManager")

signal tapped(position)
signal released()
signal destroyed(position)

func _ready():
	connect("tapped", input, "node_tapped")
	connect("released", input, "node_released")
	connect("destroyed", input, "node_destroyed")
	pass

func die():
	#print("destroying node")
	emit_signal("destroyed", global_position)
	queue_free()

func _on_TouchScreenButton_pressed():
	#print("tap")
	emit_signal("tapped", global_position)
	pass 

func _on_TouchScreenButton_released():
	emit_signal("released")
	pass 
