extends Node2D

var regex := RegEx.new()
var game_mode := ""

func _ready() -> void:
	Global.color = ""
	NetworkController.InitializeNetwork()
	NetworkController.GetIP()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/meta_scenes/main_menu.tscn")
		# Disconnect multiplayer stuff

func _on_line_edit_text_submitted(new_text: String) -> void:
	var lower := new_text.to_lower()
	regex.compile("[^a-z]")
	var cleaned := regex.sub(lower, "", true)
	var final := cleaned.capitalize()
	if final == "":
		$NameEntry/Label2.visible = true
	else:
		Global.player_name = final
		$NameEntry.visible = false
		$HostJoinMenu.visible = true

func _on_host_button_pressed() -> void:
	$HostJoinMenu.visible = false
	$PreGameLobby.visible = true
	$PreGameLobby/SelectModeLabel.visible = true
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
		rpc("BluePlayer", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func BluePlayer(player_name, id) -> void:
	$PreGameLobby/ExtractionPlayers/BlueButton.visible = false
	$PreGameLobby/ExtractionPlayers/BlueLabel.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "blue"

func _on_orange_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "orange"
		rpc("OrangePlayer", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func OrangePlayer(player_name, id) -> void:
	$PreGameLobby/ExtractionPlayers/OrangeButton.visible = false
	$PreGameLobby/ExtractionPlayers/OrangeLabel.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "orange"

func _on_pink_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "pink"
		rpc("PinkPlayer", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func PinkPlayer(player_name, id) -> void:
	$PreGameLobby/ExtractionPlayers/PinkButton.visible = false
	$PreGameLobby/ExtractionPlayers/PinkLabel.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "pink"

func _on_purple_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "purple"
		rpc("PurplePlayer", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func PurplePlayer(player_name, id) -> void:
	$PreGameLobby/ExtractionPlayers/PurpleButton.visible = false
	$PreGameLobby/ExtractionPlayers/PurpleLabel.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "purple"

func _on_white_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "white"
		rpc("WhitePlayer", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func WhitePlayer(player_name, id) -> void:
	$PreGameLobby/ExtractionPlayers/WhiteButton.visible = false
	$PreGameLobby/ExtractionPlayers/WhiteLabel.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "white"

func _on_yellow_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "yellow"
		rpc("YellowPlayer", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func YellowPlayer(player_name, id) -> void:
	$PreGameLobby/ExtractionPlayers/YellowButton.visible = false
	$PreGameLobby/ExtractionPlayers/YellowLabel.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "yellow"

func _on_ffa_button_pressed() -> void:
	if multiplayer.is_server():
		game_mode = "extraction"
		rpc("ExtractionPlayers")

func _on_one_v_one_button_pressed() -> void:
	if multiplayer.is_server():
		game_mode = "killhouse"
		rpc("KillhousePlayers")

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

@rpc("authority","call_local")
func KillhousePlayers() -> void:
	$PreGameLobby/SelectModeLabel.visible = false
	$PreGameLobby/OneVOneButton.visible = false
	$PreGameLobby/FFAButton.visible = false
	$PreGameLobby/KillhousePlayers.visible = true
	$PreGameLobby/StartGameButton.visible = true

@rpc("authority","call_local")
func ExtractionPlayers() -> void:
	$PreGameLobby/SelectModeLabel.visible = false
	$PreGameLobby/OneVOneButton.visible = false
	$PreGameLobby/FFAButton.visible = false
	$PreGameLobby/ExtractionPlayers.visible = true
	$PreGameLobby/StartGameButton.visible = true

func _on_address_entry_text_submitted(new_text: String) -> void:
	NetworkController.JoinMultiplayer(new_text)
	$JoinEntry.visible = false
	$PreGameLobby.visible = true

@rpc("authority", "call_local")
func KillHouse() -> void:
	get_tree().change_scene_to_file("res://scenes/locations_scenes/kill_house.tscn")


func _on_start_game_button_pressed() -> void:
	if game_mode == "killhouse":
		print(NetworkController.players)
		rpc("KillHouse")
	elif game_mode == "extraction":
		#rpc("Extraction")
		print(NetworkController.players)
		pass


func _on_blue_1_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "blue1"
		rpc("Blue1", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func Blue1(player_name, id) -> void:
	$PreGameLobby/KillhousePlayers/Blue1Button.visible = false
	$PreGameLobby/KillhousePlayers/Blue1Label.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "blue1"
		NetworkController.players[id].alliance = "blue"
		NetworkController.players[id].num = 0

func _on_blue_2_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "blue2"
		rpc("Blue2", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func Blue2(player_name, id) -> void:
	$PreGameLobby/KillhousePlayers/Blue2Button.visible = false
	$PreGameLobby/KillhousePlayers/Blue2Label.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "blue2"
		NetworkController.players[id].alliance = "blue"
		NetworkController.players[id].num = 1

func _on_red_1_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "red1"
		rpc("Red1", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func Red1(player_name, id) -> void:
	$PreGameLobby/KillhousePlayers/Red1Button.visible = false
	$PreGameLobby/KillhousePlayers/Red1Label.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "red1"
		NetworkController.players[id].alliance = "red"
		NetworkController.players[id].num = 2

func _on_red_2_button_pressed() -> void:
	if Global.color != "":
		pass
	else:
		Global.color = "red2"
		rpc("Red2", Global.player_name, multiplayer.get_unique_id())

@rpc("any_peer","call_local")
func Red2(player_name, id) -> void:
	$PreGameLobby/KillhousePlayers/Red2Button.visible = false
	$PreGameLobby/KillhousePlayers/Red2Label.text = player_name
	if multiplayer.is_server():
		NetworkController.players[id].color = "red2"
		NetworkController.players[id].alliance = "red"
		NetworkController.players[id].num = 3
