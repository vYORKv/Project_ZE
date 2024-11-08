extends Node2D

const PLAYER := preload("res://scenes/actor_scenes/player_mp.tscn")

var countdown := 5
var spawns := [Vector2(-62, 1342),Vector2(-62, 1408),Vector2(1218, 1342),Vector2(1218, 1408)]
var used_spawn := []
var player_array := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rpc("SpawnPlayers")
	await get_tree().create_timer(1).timeout
	if multiplayer.is_server():
		SpawnPlayers()
	await get_tree().create_timer(3).timeout
	$LevelSFX.play()
	$ColorRect/CDLabel1.text = str(countdown)
	$ColorRect2/CDLabel2.text = str(countdown)
	$StartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func StartFX() -> void:
	if countdown > 0:
		countdown -= 1
		$ColorRect/CDLabel1.text = str(countdown)
		$ColorRect2/CDLabel2.text = str(countdown)
		$LevelSFX.play()
		$StartTimer.start()
	else:
		$ColorRect.visible = false
		$ColorRect2.visible = false
		for i in player_array:
			i.input_allowed = true
		# All players can move

func _on_start_timer_timeout() -> void:
	StartFX()

#@rpc("authority", "call_local")
func SpawnPlayers() -> void:
	#var players_dict := NetworkController.players
	#var values := players_dict.values()
	#var counter = 0
	#for i in values:
		#counter += 1
		#print("Counter: " + str(counter))
		#var current_player := PLAYER.instantiate()
		#current_player.color = i.color
		#current_player.client_authority = i.id
		#current_player.player_name = i.name
		#if i.color == "blue1":
			##print("i: " + str(i) + " made it to blue1")
			#current_player.alliance = "blue"
			#current_player.global_position = Vector2(-62, 1342)
		#elif i.color == "blue2":
			##print("i: " + str(i) + " made it to blue2")
			#current_player.alliance = "blue"
			#current_player.global_position = Vector2(-62, 1408)
		#elif i.color == "red1":
			##print("i: " + str(i) + " made it to red1")
			#current_player.alliance = "red"
			#current_player.global_position = Vector2(1218, 1342)
		#elif i.color == "red2":
			##print("i: " + str(i) + " made it to red2")
			#current_player.alliance = "red"
			#current_player.global_position = Vector2(1218, 1408)
		#add_child(current_player)
		#await get_tree().create_timer(1).timeout
		### TRY AGAIN ###
		for i in NetworkController.players:
			print("i: " + str(i))
			var current_player := PLAYER.instantiate()
			player_array.push_back(current_player)
			current_player.color = NetworkController.players[i].color
			current_player.client_authority = NetworkController.players[i].id
			current_player.player_name = NetworkController.players[i].name
			current_player.alliance = NetworkController.players[i].alliance
			#if NetworkController.players[i].color == "blue1":
				##print("i: " + str(i) + " made it to blue1")
				#current_player.alliance = "blue"
				#current_player.global_position = spawns[0]
				#add_child(current_player)
				##current_player.ColorSelector(NetworkController.players[i].color)
				#await get_tree().create_timer(.05).timeout
			#if NetworkController.players[i].color == "blue2":
				##print("i: " + str(i) + " made it to blue2")
				#current_player.alliance = "blue"
				#current_player.global_position = spawns[1]
				#add_child(current_player)
				##current_player.ColorSelector(NetworkController.players[i].color)
				#await get_tree().create_timer(.05).timeout
			#if NetworkController.players[i].color == "red1":
				##print("i: " + str(i) + " made it to red1")
				#current_player.alliance = "red"
				#current_player.global_position = spawns[2]
				#add_child(current_player)
				##current_player.ColorSelector(NetworkController.players[i].color)
				#await get_tree().create_timer(.05).timeout
			#if NetworkController.players[i].color == "red2":
				##print("i: " + str(i) + " made it to red2")
				#current_player.alliance = "red"
				#current_player.global_position = spawns[3]
				#add_child(current_player)
				##current_player.ColorSelector(NetworkController.players[i].color)
				#await get_tree().create_timer(.05).timeout
			current_player.global_position = spawns[NetworkController.players[i].num]
			#current_player.global_position = ChooseSpawn()
			#current_player.ColorSelector(NetworkController.players[i].color)
			#add_child(current_player)
			call_deferred("add_child", current_player)
			#await get_tree().create_timer(.05).timeout

func ChooseSpawn() -> Vector2:
	var point = spawns.pick_random()
	used_spawn.append(point)
	spawns.erase(point)
	#var point = spawns[num]
	#print(point)
	return point
