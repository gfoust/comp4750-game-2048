# Stage 3

## Create a "back grid"
- Make `back_grid` variable, initialize in `_ready`
- Move slide logic into `slide_one`; rename `slide` to `slide_all`
  + Note `slide_one` must return bool to update `changed`
- Change `SliceItr` so that grid is not built in
  + Update `_init`, `get_tile`, and `set_tile`
  + Update code using iters to pass `grid`
- Update `slide_one` with logic for merging tiles
- Update `move_tiles` to iterate over both grids
- Update `on_tile_move_done` to delete merged
- Update `Tile` to animate color changes
  + Use `init` parameter to distinguish between initial value and change
