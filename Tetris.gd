extends Control

const CELL_SIZE = 32.0

export var columns = 10
export var rows = 14
export var speed = 1.0 setget set_speed

var current_block: Node2D
var next_block: Node2D

var shapes = [
	preload("res://Tetris Bricks/I.tscn"),
	preload("res://Tetris Bricks/J.tscn"),
	preload("res://Tetris Bricks/L.tscn"),
	preload("res://Tetris Bricks/O.tscn"),
	preload("res://Tetris Bricks/S.tscn"),
	preload("res://Tetris Bricks/T.tscn"),
	preload("res://Tetris Bricks/Z.tscn"),
]

signal block_placed
signal line_cleared
signal game_lost


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	respawn()
	$Timer.start()


func pause():
	$Timer.stop()


func unpause():
	$Timer.start()


func set_speed(speed: float):
	$Timer.wait_time = 1.0 / speed


func game_lost():
	print("You lose!")
	emit_signal("game_lost")


func respawn():
	if current_block != null:
		self.remove_child(current_block)
	if next_block == null:
		next_block = shapes[randi() % shapes.size()].instance()
	$NextBlock.remove_child(next_block)
	current_block = next_block.duplicate()
	current_block.position = Vector2(columns/2 - 2, 0) * CELL_SIZE
	if collide(current_block):
		game_lost()
		current_block = null
	else:
		self.add_child(current_block)
	
	next_block = shapes[randi() % shapes.size()].instance()
	$NextBlock.add_child(next_block)


func check_row(row):
	for i in range(columns):
		if $Playfield.get_cell(i, row) == -1:
			return false
	return true
	

func delete_row(row):
	for j in range(row, 1, -1):
		for i in range(columns):
			$Playfield.set_cell(i, j, $Playfield.get_cell(i, j-1))
	
	for i in range(columns):
		$Playfield.set_cell(i, 0, -1)


func _on_Timer_timeout():
	if current_block != null:
		if not try_move(current_block, Vector2(0, 1)):
			var pos = current_block.position / CELL_SIZE
			for cell in current_block.get_current().get_used_cells():
				$Playfield.set_cell(cell.x + pos.x, cell.y + pos.y, current_block.get_current().get_cell(cell.x, cell.y))
			emit_signal("block_placed")
			for i in range(rows):
				if check_row(i):
					delete_row(i)
					emit_signal("line_cleared")
			respawn()


func try_move(block, direction: Vector2) -> bool:
	var old_position = block.position
	block.position += direction * CELL_SIZE
	if collide(block):
		block.position = old_position
		return false
	return true


func try_rotate(block, clockwise: bool):
	if clockwise:
		block.next_shape()
	else:
		block.prev_shape()
	if collide(block):
		if clockwise:
			block.prev_shape()
		else:
			block.next_shape()


func collide(block) -> bool:
	var pos = block.position / CELL_SIZE
	
	for cell in current_block.get_current().get_used_cells():
		cell += pos
		if cell.x < 0 or cell.x >= columns or cell.y < 0 or cell.y >= rows:
			return true
		if $Playfield.get_cell(cell.x, cell.y) != -1:
			return true
	
	return false


func _input(event):
	if $Timer.is_stopped():
		return
	
	if event is InputEventKey and event.pressed:
		if current_block != null:
			match event.scancode:
				KEY_LEFT:
					try_move(current_block, Vector2(-1, 0))
				KEY_RIGHT:
					try_move(current_block, Vector2(1, 0))
				KEY_UP:
					try_rotate(current_block, true)
				KEY_SHIFT:
					try_rotate(current_block, false)
				KEY_DOWN:
					if try_move(current_block, Vector2(0, 1)):
						$Timer.start()
				KEY_SPACE:
					while try_move(current_block, Vector2(0, 1)):
						$Timer.start()
