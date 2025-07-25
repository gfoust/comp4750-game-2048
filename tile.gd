@tool
class_name Tile
extends Node2D

const SIZE = 120

const COLORS := [
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
var tween: Tween

func _ready() -> void:
	_update_tile(false)


func _set_power(value: int) -> void:
	power = value
	if is_node_ready():
		_update_tile(true)


func _update_tile(animate: bool) -> void:
	label.text = str(2**power)
	if animate:
		create_tween().tween_property(rect, "color", COLORS[power], 0.33333)
	else:
		rect.color = COLORS[power]
