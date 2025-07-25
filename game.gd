extends Panel

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var label: Label = $GameOverScreen/Panel/Label
@onready var board: ColorRect = $Board
@onready var button: Button = $GameOverScreen/Panel/Button


func _ready() -> void:
	game_over_screen.hide()


func _on_board_game_over(win: bool) -> void:
	if win:
		label.text = "You Win!"
	else:
		label.text = "You lose."
	game_over_screen.show()
	button.grab_focus()


func _on_button_pressed() -> void:
	game_over_screen.hide()
	board.reset()
