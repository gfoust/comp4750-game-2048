extends ColorRect

const GRID_SIZE := 4

enum Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT
}


var listening := true
var grid: Array[Array]
var empty_tiles := GRID_SIZE * GRID_SIZE
var tile_scene: PackedScene = load("res://tile.tscn")


func _ready() -> void:
	grid.resize(GRID_SIZE)
	for row: Array[Tile] in grid:
		row.resize(GRID_SIZE)
	add_tile_to_grid()


func _input(event: InputEvent) -> void:
	if listening:
		var moved := false
		if event.is_action_pressed("ui_left"):
			moved = slide(Dir.LEFT)
		elif event.is_action_pressed("ui_right"):
			moved = slide(Dir.RIGHT)
		elif event.is_action_pressed("ui_up"):
			moved = slide(Dir.UP)
		elif event.is_action_pressed("ui_down"):
			moved = slide(Dir.DOWN)
		if moved:
			move_tiles()


func _on_tile_move_done() -> void:
	add_tile_to_grid()


func move_tiles():
	listening = false
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	for x in range(4):
		for y in range(4):
			var tile: Tile = grid[y][x]
			if tile:
				tween.tween_property(
					tile,
					"position",
					Vector2(x * Tile.SIZE, y * Tile.SIZE),
					0.3333
				)
	tween.set_parallel(false)
	tween.tween_callback(add_tile_to_grid)


func make_tile(x: int, y: int) -> Tile:
	empty_tiles -= 1
	var tile = tile_scene.instantiate()
	tile.power = 1
	tile.position.x = x * Tile.SIZE
	tile.position.y = y * Tile.SIZE
	add_child(tile)
	return tile


func add_tile_to_grid() -> void:
	listening = true
	if empty_tiles > 0:
		var n := randi() % empty_tiles
		for x in range(4):
			for y in range(4):
				if grid[y][x] == null:
					if n == 0:
						grid[y][x] = make_tile(x, y)
						return
					else:
						n -= 1


func slide(dir: Dir) -> bool:
	var changed := false
	for i in range(GRID_SIZE):
		var src = SliceItr.new(grid, dir, i)
		var dst = SliceItr.new(grid, dir, i)
		while src.good() and src.get_tile() != null:
			src.next()
			dst.next()
		while src.good():
			if src.get_tile() != null:
				dst.set_tile(src.get_tile())
				dst.next()
				src.set_tile(null)
				changed = true
			src.next()
	return changed


class SliceItr:
	var _grid: Array[Array]
	var _start_dir: Dir
	var _along: int
	var _x_axis: bool
	var _current: int
	var _end: int
	var _inc: int


	func _init(grid: Array[Array], start_dir: Dir, along: int) -> void:
		_start_dir = start_dir
		_grid = grid
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


	func get_tile() -> Tile:
		if _x_axis:
			return _grid[_along][_current] as Tile
		else:
			return _grid[_current][_along] as Tile


	func set_tile(tile: Tile) -> void:
		if _x_axis:
			_grid[_along][_current] = tile
		else:
			_grid[_current][_along] = tile


	func next() -> void:
		_current += _inc
