extends ColorRect

signal game_over(win: bool)

const GRID_SIZE := 4

const POWER_PROBABILITIES = [
	[ 100,  0,  0,  0 ],
	[ 100,  0,  0,  0 ],
	[  95,  5,  0,  0 ],
	[  90, 10,  0,  0 ],
	[  88, 12,  0,  0 ],
	[  85, 15,  0,  0 ],
	[  83, 15,  2,  0 ],
	[  82, 15,  3,  0 ],
	[  81, 15,  3,  1 ],
	[  80, 15,  3,  2 ],
	[  80, 15,  3,  2 ],
]

enum Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var goal := 11

var listening := true
var grid: Array[Array]
var back_grid: Array[Array]
var empty_tiles := GRID_SIZE * GRID_SIZE
var tile_scene: PackedScene = load("res://tile.tscn")
var max_power := 1


func _ready() -> void:
	grid.resize(GRID_SIZE)
	for row: Array[Tile] in grid:
		row.resize(GRID_SIZE)
	back_grid.resize(GRID_SIZE)
	for row: Array[Tile] in back_grid:
		row.resize(GRID_SIZE)
	add_tile_to_grid()


func _input(event: InputEvent) -> void:
	if listening:
		var moved := false
		if event.is_action_pressed("ui_left"):
			moved = slide_all(Dir.LEFT)
		elif event.is_action_pressed("ui_right"):
			moved = slide_all(Dir.RIGHT)
		elif event.is_action_pressed("ui_up"):
			moved = slide_all(Dir.UP)
		elif event.is_action_pressed("ui_down"):
			moved = slide_all(Dir.DOWN)
		if moved:
			move_tiles()


func _on_tile_move_done() -> void:
	for x in range(4):
		for y in range(4):
			if back_grid[x][y] != null:
				back_grid[x][y].queue_free()
				back_grid[x][y] = null
	if max_power == goal:
		game_over.emit(true)
	else:
		add_tile_to_grid()


func no_more_moves_possible() -> bool:
	for i in range(4):
		for j in range(3):
			if grid[i][j].power == grid[i][j + 1].power:
				return false
			if grid[j][i].power == grid[j + 1][i].power:
				return false
	return true


func reset() -> void:
	for row in grid:
		for y in range(4):
			if row[y]:
				row[y].queue_free()
				row[y] = null
	empty_tiles = GRID_SIZE * GRID_SIZE
	listening = true
	add_tile_to_grid()


func move_tiles():
	listening = false
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	for x in range(4):
		for y in range(4):
			for g in [grid, back_grid]:
				var tile: Tile = g[y][x]
				if tile:
					tween.tween_property(
						tile,
						"position",
						Vector2(x * Tile.SIZE, y * Tile.SIZE),
						0.3333
					)
	tween.set_parallel(false)
	tween.tween_callback(_on_tile_move_done)


func pick_power():
	var rand_num = randi() % 100
	var total:= 0
	var probs = POWER_PROBABILITIES[max_power - 1]
	for i in range(probs.size()):
		total += probs[i]
		if rand_num < total:
			return i + 1
	return 0


func make_tile(x: int, y: int) -> Tile:
	empty_tiles -= 1
	var tile = tile_scene.instantiate()
	tile.power = pick_power()
	tile.position.x = x * Tile.SIZE
	tile.position.y = y * Tile.SIZE
	tile.z_index = 100
	add_child(tile)
	return tile


func add_tile_to_grid() -> void:
	if empty_tiles > 0:
		var n := randi() % empty_tiles
		for x in range(4):
			for y in range(4):
				if grid[y][x] == null:
					if n == 0:
						grid[y][x] = make_tile(x, y)
					n -= 1
	if empty_tiles == 0 and no_more_moves_possible():
		game_over.emit(false)
	else:
		listening = true


func slide_one(src: SliceItr, dst: SliceItr) -> bool:
	if src.equals(dst):
		return false
	else:
		if dst.get_tile(grid) == null:
			dst.set_tile(grid, src.get_tile(grid))
			src.set_tile(grid, null)
			return true
		elif dst.get_tile(grid).power == src.get_tile(grid).power:
			dst.set_tile(back_grid, src.get_tile(grid))
			dst.get_tile(back_grid).z_index = 10
			src.set_tile(grid, null)
			var new_power = dst.get_tile(grid).power + 1
			dst.get_tile(grid).power = new_power
			dst.next()
			empty_tiles += 1
			if new_power > max_power:
				max_power = new_power
			return true
		else:
			dst.next()
			return slide_one(src, dst)


func slide_all(dir: Dir) -> bool:
	var changed := false
	for i in range(GRID_SIZE):
		var src := SliceItr.new(dir, i)
		var dst := SliceItr.new(dir, i)
		src.next()
		while src.good():
			if src.get_tile(grid) != null:
				if slide_one(src, dst):
					changed = true
			src.next()
	return changed


class SliceItr:
	var _start_dir: Dir
	var _along: int
	var _x_axis: bool
	var _current: int
	var _end: int
	var _inc: int


	func _init(start_dir: Dir, along: int) -> void:
		_start_dir = start_dir
		_along = along
		_x_axis = start_dir == Dir.LEFT or start_dir == Dir.RIGHT
		if start_dir == Dir.LEFT or start_dir == Dir.UP:
			_current = 0
			_end = GRID_SIZE
			_inc = 1
		else:
			_current = GRID_SIZE - 1
			_end = -1
			_inc = -1


	func good() -> bool:
		return _current != _end


	func get_tile(grid: Array) -> Tile:
		if _x_axis:
			return grid[_along][_current] as Tile
		else:
			return grid[_current][_along] as Tile


	func set_tile(grid: Array, tile: Tile) -> void:
		if _x_axis:
			grid[_along][_current] = tile
		else:
			grid[_current][_along] = tile


	func next() -> void:
		_current += _inc


	func equals(other: SliceItr) -> bool:
		return _current == other._current
