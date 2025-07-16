# Stage 1

1.  Start with Tile scene
	- Node2D
	- Add ColorRect
	  + Set color
	  + Set size to 119x119 (Layout, Transform)
	  + Set offset to (1, 1)
	  + This makes it 120x120, with border at top-left
	- Add Label (under ColorRect)
	  + Set text
	  + Fill ColorRect
	  + Set Horizontal and Vertical Align properties
	  + Set font size = 64px
2.  Make a tile script
	- Class name
	- Make power var (export, init 1)
	- Create _ready method
	  + Set label text to `str(2**power)` (view)
	  + Make a Color array
		```
		const colors := [
			Color.BLACK,
			Color.DARK_BLUE,
			Color.DARK_CYAN,
			Color.CADET_BLUE,
			Color.SEA_GREEN,
			Color.WEB_GREEN,
			Color.YELLOW_GREEN,
			Color.DARK_KHAKI,
			Color.GOLDENROD,
			Color.ORANGE,
			Color.ORANGE_RED,
			Color.DARK_RED
		]
		```
	  + Set color to `colors[power]`
3.  Make a board scene
	- Start this one with ColorRect
	- Add a tile
	  + Play with power
	  + Make setter
	  + Make _update_tile
	  + Make tile a tool
	- Add script
	  + Use _input method to move tile to edges
	  + Add tween to animate the movement
	- Notice what happens when you change directions quickly
	  + Make a `listening` variable (true)
			+ Make `move_tile` that does the tween
			  * Branches on input call `move_tile`
				* Set `ready` to false
			+ Make a `_on_move_tile_done` for when it is done
			  * Set `ready` to true
			+ Put input branch into if statement
