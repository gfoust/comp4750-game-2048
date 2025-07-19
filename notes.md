# Stage 2

## Get rid of individual tile

- Delete tile from board
- In `_input` change if branches to `pass`
- In `move_tiles` remove `tween_property`

## Add tiles dynamically

- Make `GRID_SIZE` and `TILE_SIZE`
- Make `grid` variable
- Set sizes in `_ready` (or `_init`?)
- Make `add_tile_to_grid`
  + Save `listening = true` for later
  + Make `empty_tiles` variable
  + Put in nth empty slot, where n is random
  + Note: NOT `Tile.new()`; instead...
- Make `make_tile`
  + Make `tile_scene` variable
  + Create / initialize tile
- Add input for `ui_accept` to call `add_tile_to_grid`

## Make tiles slide

- Discuss abstraction, leading to iterator
  + Discuss Godot iterators
  + Discuss iterating over `Vector2i`
  + Make `get_tile` and `set_tile` to help
- Make `Dir` enum
- Make `Slice` iterator
  + Make fields / `_init`
  + Make iterator methods (wait on `_iter_copy`)
- Make `slide` method
  + Note: rearranging array has no visual effect
- Revisit `move_tiles`
  + Save `set_parallel`
  + Save trans/ease
- Debugging
  - Move `listening = true` from `ready` to `add_tile_to_grid`
  - Add `set_parallel`
  - Add trans/ease
