extends Node

const CROSSHAIR := preload("res://assets/graphics/ui/crosshair.png")

var solo_run_win := false

func Crosshair() -> void:
	Input.set_custom_mouse_cursor(CROSSHAIR)

func Cursor() -> void:
	Input.set_custom_mouse_cursor(null)
