extends Control

const LAYERS_PER_DATA = 2
const LAYERS_SPEED_COEF = 10.0
const INVESTOR_TIMER = 8.0

var started = false
var pause = true
var lost = false
var data = 0
var blocks = 0
var layers = 0
var best_accuracy = 0.5
var next_block = null


func game_lost(tetris: bool):
	$Tetris.pause()
	lost = true
	if tetris:
		$GameLostTetris.visible = true
		print("You lost because of Tetris")
	else:
		$GameLostInvestors.visible = true
		print("You lost because of investors")


func toggle_pause():
	if pause:
		pause = false
		$Tetris.unpause()
		$PauseScreen.visible = false
	else:
		pause = true
		$Tetris.pause()
		$PauseScreen.visible = true


func max_accuracy() -> float:
	return (1.0 - 1.0/(1.0 + layers))/2.0


func fitting() -> float:
	return (1.0 + tanh(data - LAYERS_PER_DATA * layers)) / 2.0


func accuracy() -> float:
	return 0.5 + min(1.0, 2*fitting()) * max_accuracy()


func investors_freakout():
	$InvestorAlert.visible = true
	$InvestorAlert/Timer.start()


func investors_okay():
	$InvestorAlert.visible = false
	$InvestorAlert/Timer.stop()


func update():
	print("%f %f %f" % [max_accuracy(), (1 + fitting())/2, accuracy()])
	$Gauge.value = fitting()
	$Stats/Accuracy/Value.text = "%.4f%%" % (accuracy() * 100)
	$Stats/Accuracy/BestValue.text = "(%.4f%%)" % (best_accuracy * 100)
	$Stats/Data/Value.text = "%d" % data
	$Stats/Layers/Value.text = "%d" % layers
	
#	if accuracy >= best_accuracy:
	print(-log(1 - accuracy()))
	
	if accuracy() >= best_accuracy:
		best_accuracy = accuracy()
		investors_okay()
	else:
		investors_freakout()
	
	$Tetris.speed = 1 + layers / LAYERS_SPEED_COEF


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	toggle_pause()
	update()
	$InvestorAlert/Timer.wait_time = INVESTOR_TIMER
	$StartScreen.visible = true
	$Tetris.pause()
#	investors_freakout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $InvestorAlert/Timer.is_stopped():
		var amount = $InvestorAlert/Timer.time_left / $InvestorAlert/Timer.wait_time
		$InvestorAlert/Gauge/InnerGauge.rect_size.x = lerp(0, $InvestorAlert/Gauge.rect_size.x, amount)


func _on_Captcha_captcha_valid():
	data += 1
	update()


func _on_Captcha_captcha_wrong():
	pass # Replace with function body.


func _on_Tetris_block_placed():
	blocks += 4
#	update()


func _on_Tetris_line_cleared():
	layers += 1
	update()


func _on_Tetris_game_lost():
	game_lost(true)


func _input(event):
	if lost:
		return
	
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_ESCAPE:
				if started:
					toggle_pause()
				else:
					started = true
					$StartScreen.visible = false
					$Tetris.unpause()


func _on_Timer_timeout():
	game_lost(false)
