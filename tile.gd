@tool
class_name Tile
extends Node2D

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


@export var power: int = 1:
	set = _set_power

@onready var rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

func _ready() -> void:
	_update_tile()


func _set_power(value: int) -> void:
	power = value
	if is_node_ready():
		_update_tile()


func _update_tile() -> void:
	label.text = str(2**power)
	rect.color = colors[power]
