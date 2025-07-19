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


func get_tile(pos: Vector2i) -> Tile:
	return grid[pos.y][pos.x]


func set_tile(pos: Vector2i, tile: Tile) -> void:
	grid[pos.y][pos.x] = tile


func slide(dir: Dir) -> bool:
	var changed := false
	for i in range(GRID_SIZE):
		var slice := Slice.new(dir, i)
		var src := [0]
		var dst := [0]
		var good := slice._iter_init(src)
		slice._iter_init(dst)
		while good and get_tile(slice._iter_get(src[0])) != null:
			good = slice._iter_next(src)
			slice._iter_next(dst)
		while good:
			var src_pos: Vector2i = slice._iter_get(src[0])
			var tile := get_tile(src_pos)
			if tile != null:
				var dst_pos: Vector2i = slice._iter_get(dst[0])
				set_tile(dst_pos, tile)
				set_tile(src_pos, null)
				slice._iter_next(dst)
				changed = true
			good = slice._iter_next(src)
	return changed


class Slice:
	var _begin: int
	var _end: int
	var _inc: int
	var _x_axis: bool
	var _other: int


	func _init(start: Dir, along: int) -> void:
		if start == Dir.LEFT or start == Dir.UP:
			_begin = 0
			_end = GRID_SIZE
			_inc = 1
		else:
			_begin = GRID_SIZE - 1
			_end = -1
			_inc = -1
		_x_axis = start == Dir.LEFT or start == Dir.RIGHT
		_other = along


	func _iter_init(iter: Array) -> bool:
		iter[0] = _begin
		return iter[0] != _end


	func _iter_get(current: Variant) -> Variant:
		if _x_axis:
			return Vector2(current as int, _other)
		else:
			return Vector2(_other, current as int)


	func _iter_next(iter: Array) -> bool:
		iter[0] = iter[0] + _inc
		return iter[0] != _end
