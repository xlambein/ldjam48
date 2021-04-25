tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_children():
		child.visible = false
	self.get_child(current).visible = true
	

func get_current():
	return self.get_child(current)


func next_shape():
	self.get_child(current).visible = false
	self.current = (self.current + 1) % self.get_child_count()
	self.get_child(current).visible = true


func prev_shape():
	self.get_child(current).visible = false
	self.current = (self.current + self.get_child_count() - 1) % self.get_child_count()
	self.get_child(current).visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
