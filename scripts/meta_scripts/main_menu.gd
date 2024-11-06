extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.Cursor()
	print("Main Menu Parent: " + str(get_parent()))
	print("Main Menu Tree: " + str(get_tree()))
	if Global.solo_run_win:
		$SoloWinLabel.visible = true

func _on_solo_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/locations_scenes/solo_run.tscn")

func _on_multiplayer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/meta_scenes/lobby.tscn")

func _on_options_button_pressed() -> void:
	$MainButtons.visible = false
	$Controls.visible = true
	$ChangelogButton.disabled = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_test_arena_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/locations_scenes/test_arena.tscn")

func _on_controls_back_button_pressed() -> void:
	$Controls.visible = false
	$MainButtons.visible = true
	$ChangelogButton.disabled = false

func _on_changelog_button_pressed() -> void:
	$MainButtons.visible = false
	$Changelog.visible = true

func _on_cl_back_button_pressed() -> void:
	$MainButtons.visible = true
	$Changelog.visible = false
