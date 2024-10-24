extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(.05).timeout
	get_tree().change_scene_to_file("res://scenes/meta_scenes/main_menu.tscn")
