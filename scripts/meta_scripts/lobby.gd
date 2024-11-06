extends Node2D

var regex = RegEx.new()

func _ready() -> void:
	Global.color = ""
	NetworkController.InitializeNetwork()
	NetworkController.GetIP()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/meta_scenes/main_menu.tscn")
		# Disconnect multiplayer stuff

func _on_line_edit_text_submitted(new_text: String) -> void:
	var lower = new_text.to_lower()
	regex.compile("[^a-z]")
	var cleaned = regex.sub(lower, "", true)
	var final = cleaned.capitalize()
	if final == "":
		$NameEntry/Label2.visible = true
	else:
		Global.player_name = final
		$NameEntry.visible = false
		$HostJoinMenu.visible = true

func _on_host_button_pressed() -> void:
	$HostJoinMenu.visible = false
	$PreGameLobby.visible = true
	$PreGameLobby/StartGameLabel.visible = true
	$PreGameLobby/OneVOneButton.visible = true
	$PreGameLobby/FFAButton.visible = true
	$PreGameLobby/IPLabel.visible = true
	$PreGameLobby/IPLabel.text = "Your IP address: " + NetworkController.ip_address
	NetworkController.HostMultiplayer()

func _on_join_button_pressed() -> void:
	$HostJoinMenu.visible = false
	$JoinEntry.visible = true

func _on_je_back_button_pressed() -> void:
	$JoinEntry.visible = false
	$HostJoinMenu.visible = true

func _on_blue_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "blue"
		rpc("BluePlayer", Global.player_name)

@rpc("any_peer","call_local")
func BluePlayer(player_name) -> void:
	$PreGameLobby/BlueButton.visible = false
	$PreGameLobby/BlueLabel.text = player_name

func _on_orange_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "orange"
		rpc("OrangePlayer", Global.player_name)

@rpc("any_peer","call_local")
func OrangePlayer(player_name) -> void:
	$PreGameLobby/OrangeButton.visible = false
	$PreGameLobby/OrangeLabel.text = player_name

func _on_pink_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "pink"
		rpc("PinkPlayer", Global.player_name)

@rpc("any_peer","call_local")
func PinkPlayer(player_name) -> void:
	$PreGameLobby/PinkButton.visible = false
	$PreGameLobby/PinkLabel.text = player_name

func _on_purple_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "purple"
		rpc("PurplePlayer", Global.player_name)

@rpc("any_peer","call_local")
func PurplePlayer(player_name) -> void:
	$PreGameLobby/PurpleButton.visible = false
	$PreGameLobby/PurpleLabel.text = player_name

func _on_white_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "white"
		rpc("WhitePlayer", Global.player_name)

@rpc("any_peer","call_local")
func WhitePlayer(player_name) -> void:
	$PreGameLobby/WhiteButton.visible = false
	$PreGameLobby/WhiteLabel.text = player_name

func _on_yellow_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "yellow"
		rpc("YellowPlayer", Global.player_name)

@rpc("any_peer","call_local")
func YellowPlayer(player_name) -> void:
	$PreGameLobby/YellowButton.visible = false
	$PreGameLobby/YellowLabel.text = player_name

func _on_ffa_button_pressed() -> void:
	pass # Replace with function body.

func _on_one_v_one_button_pressed() -> void:
	rpc("KillHouse")

func _on_chat_entry_text_submitted(new_text: String) -> void:
	if new_text == "":
		pass
	else:
		rpc("ChatRPC", Global.player_name, new_text)
		#ChatRPC(Global.player_name, new_text)
		$PreGameLobby/ChatEntry.text = ""

@rpc("any_peer","call_local")
func ChatRPC(player_name,text) -> void:
	$PreGameLobby/ChatBox.text += str(player_name) + ": " + str(text) + "\n"
	$PreGameLobby/ChatBox.scroll_vertical = $PreGameLobby/ChatBox.get_line_count()

func _on_address_entry_text_submitted(new_text: String) -> void:
	NetworkController.JoinMultiplayer(new_text)
	$JoinEntry.visible = false
	$PreGameLobby.visible = true

@rpc("authority", "call_local")
func KillHouse() -> void:
	get_tree().change_scene_to_file("res://scenes/locations_scenes/kill_house.tscn")
