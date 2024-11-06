extends Node

const CROSSHAIR := preload("res://assets/graphics/ui/crosshair.png")

var player_name := "Player"
var color := ""

var solo_run_win := false


func Crosshair() -> void:
	Input.set_custom_mouse_cursor(CROSSHAIR)

func Cursor() -> void:
	Input.set_custom_mouse_cursor(null)
