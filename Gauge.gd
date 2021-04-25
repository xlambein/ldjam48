extends Control


export var value = 0.5 setget set_value


func set_value(val: float):
	value = val
	$Gauge/Cursor.position.x = lerp(0.0, $Gauge.rect_size.x, value)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
