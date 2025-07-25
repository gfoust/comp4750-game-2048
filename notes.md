# Stage 4

## Make a game scene
- Make a panel with a label and a board
  + Panel 496x577
  + Add theme override
  + Border-width 8 (#eee)
  + Label font size 64px, shadow
  + Board offset 8, 88
- Run
  + Set main scene
  + Set window dimensions 496x577
  + Set stretch mode = canvas items

## Make a game over screen
- Add CanvasLayer
- Add Label
  + Save previous label's settings and load them here
  + Center; add newline to push up slightly
- Add Button
- Run program to show
- Hide it

## Detect when game is won
- Add game_over(bool) signal to board
- Add `goal_reached` function
  + Export a goal variable for goal
- Add branch to end of `_on_tile_move_done` to emit signal when goal reached
  + Point out that listening will remain false

## Add game over logic
- Add script to game
- Add handler for game_over signal
  + Set label text, show screen
  + Focus button
- Add handler for button press
- Add reset function to board
- Test win and reset

## Detect when game is lost
- Note that `empty_tiles == 0` is not enough
- Add `no_more_moves_possible` function
- Remove return
  + Discuss issue with breaking out of nested loop
  + Allow loop to finish
- Move `listening = true` to end
- Add branch to test for lost game at the end
