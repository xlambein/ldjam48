tool
extends Control


var target_label = Globals.TrainingLabel.TRUCK
#export(Globals.TrainingLabel) var target_label = Globals.TrainingLabel.TRUCK
export(int, 1, 10, 1) var rows = 3
export(int, 1, 10, 1) var columns = 3
export var margin: Vector2 = 8.0 * Vector2.ONE

var CaptchaImageScene = preload("res://Captcha Image.tscn")

var images = []


signal captcha_valid
signal captcha_wrong


# Called when the node enters the scene tree for the first time.
func _ready():
	var size = ($ImagesRect.rect_size - margin * Vector2(rows-1, columns-1)) / Vector2(rows, columns)
	
	target_label = Globals.random_label()
	
	match target_label:
		Globals.TrainingLabel.PUPPER:
			 $TextRect/TargetLabel.text = "puppers"
		Globals.TrainingLabel.TRUCK:
			 $TextRect/TargetLabel.text = "trucks"
	
	images = []
	for i in range(rows):
		images.append([])
		for j in range(columns):
			var ci = CaptchaImageScene.instance()
			ci.type = Globals.TrainingLabel.values()[randi() % Globals.TrainingLabel.size()]
			ci.set_size(size)
			ci.set_position(Vector2(i, j) * (size + margin))
			ci.connect("pressed", self, "image_pressed", [i, j])
			$ImagesRect.add_child(ci)
			images[i].append(ci)


func image_pressed(i: int, j: int):
	pass
#	var type = images[i][j].type


func _on_VerifyButton_pressed():
	print("hello")
	for row in images:
		for image in row:
			if (image.type == target_label) != image.pressed:
				emit_signal("captcha_wrong")
				return
	
	emit_signal("captcha_valid")
	delete_children($ImagesRect)
	_ready()
	

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
