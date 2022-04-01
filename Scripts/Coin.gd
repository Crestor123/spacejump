extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "coin")

func die():
	queue_free()
