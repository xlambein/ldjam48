tool
extends TextureButton

class_name CaptchaImage

export(Globals.TrainingLabel) var type = Globals.TrainingLabel.PUPPER

const HOVER_SCALE = 1.05
const CLICK_SCALE = 0.85
const TOGGLED_SCALE = 0.85

var texture


# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		Globals.TrainingLabel.PUPPER:
			texture = load("res://images/pupper001.tres")
		Globals.TrainingLabel.TRUCK:
			texture = load("res://images/truck001.tres")
	self.texture_normal = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func scale(scale: float):
	self.rect_scale = scale * Vector2.ONE


func _on_Captcha_Image_mouse_entered():
	pass
#	self.scale(HOVER_SCALE * (TOGGLED_SCALE if self.pressed else 1.0))
	

func _on_Captcha_Image_mouse_exited():
	pass
#	self.scale(TOGGLED_SCALE if self.pressed else 1.0)


func _on_Captcha_Image_button_down():
	pass
#	self.scale(CLICK_SCALE)


func _on_Captcha_Image_button_up():
	pass
#	self.scale(HOVER_SCALE * (TOGGLED_SCALE if self.pressed else 1.0))


func _on_Captcha_Image_pressed():
	self.scale(TOGGLED_SCALE if self.pressed else 1.0)
