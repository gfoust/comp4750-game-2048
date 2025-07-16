extends ColorRect

@onready var tile: Tile = $Tile

var listening := true

func _input(event: InputEvent) -> void:
	if listening:
		if event.is_action_pressed("ui_left"):
			move_tiles(0, tile.position.y)
		elif event.is_action_pressed("ui_right"):
			move_tiles(150, tile.position.y)
		elif event.is_action_pressed("ui_up"):
			move_tiles(tile.position.x, 0)
		elif event.is_action_pressed("ui_down"):
			move_tiles(tile.position.x, 150)


func move_tiles(x: int, y: int):
	listening = false
	var tween = create_tween()
	tween.tween_property(tile,"position",Vector2(x, y),0.3333)
	tween.tween_callback(_on_tile_move_done)


func _on_tile_move_done() -> void:
	listening = true
