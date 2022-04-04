extends KinematicBody2D

#Move toward player slowly
#Function as node for player movement
#Die when touching a wall

signal tapped(position)
signal released
signal destroyed

var nodePosition = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func die():
	queue_free()

func _on_TouchScreenButton_pressed():
	pass # Replace with function body.

func _on_TouchScreenButton_released():
	pass # Replace with function body.
