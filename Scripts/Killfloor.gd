extends Area2D

onready var collision = $KillfloorCollision

func _ready():
	pass
	
func _on_Killfloor_body_entered(body):
	if body.has_method("die"):
		body.die()
