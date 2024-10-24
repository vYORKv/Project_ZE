extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_solo_button_pressed() -> void:
	pass # Replace with function body.


func _on_multiplayer_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	$MainButtons.visible = false
	$Controls.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_test_arena_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/locations_scenes/test_arena.tscn")


func _on_controls_back_button_pressed() -> void:
	$Controls.visible = false
	$MainButtons.visible = true
