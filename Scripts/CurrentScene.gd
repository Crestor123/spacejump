extends Node

signal reloaded
signal changedScene

var main = "res://Scenes/Main.tscn"

func _ready():
	pass # Replace with function body.

func reload():
	var scene
	for child in self.get_children():
		child.queue_free()
	scene = load(main).instance()
	self.add_child(scene)
	pass
	
func changeScene():
	pass
