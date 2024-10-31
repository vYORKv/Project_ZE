extends Node2D


const ZOMBIE := preload("res://scenes/actor_scenes/zombie.tscn")
const FOOD := preload("res://scenes/items_scenes/food.tscn")
const WATER := preload("res://scenes/items_scenes/water.tscn")
const BANDAGE := preload("res://scenes/items_scenes/bandage.tscn")
const PILLS := preload("res://scenes/items_scenes/pills.tscn")
const HANDGUN := preload("res://scenes/items_scenes/handgun.tscn")
const RIFLE := preload("res://scenes/items_scenes/rifle.tscn")
const SHOTGUN := preload("res://scenes/items_scenes/shotgun.tscn")
const ROUND_START := preload("res://assets/audio/music/round_start.wav")
const GAME_OVER := preload("res://assets/audio/music/game_over.wav")
const HORDE_APPROACHES := preload("res://assets/audio/zombie_sfx/horde_approaches.wav")

@onready var Player := $Player
@onready var HordeTimer := $HordeTimer
@onready var LevelSFX := $LevelSFX

var zombies_spawned := false
var items_spawned := false
var medical_spawned := false
var weapons_spawned := false
var horde_timer_active := false
var game_over := false

var meta_ready := false # Create a timer at beginning of mission. On timeout,
						# set this to true, then call function that spawns meta
						# wave, sets this to false, then starts a timer for their
						# spawn rate. On that timer timeout, call spawn function again.
						# CAUTION: Ignore the above comments. Likely do not need
						# this bool, only a timer. Timer at mission start that
						# starts spawning of horde, then recursive function calls
						# on spawn_ready timer timeout until mission finished.
var meta_spawn_ready := false

func _ready() -> void:
	Global.Crosshair()
	print("Solo Run Parent: " + str(get_parent()))
	print("Solo Run Tree: " + str(get_tree()))
	Player.VisionCone.visible = false
	SpawnZombies()
	SpawnItems()
	SpawnMedicals()
	SpawnWeapons()
	#AllowInput()
	## Need to call a function here that starts an intro animation. Upon animation
	## finishing, allows player input and starts the meta_horde timer
	await get_tree().create_timer(5).timeout
	Player.VisionCone.visible = true
	Player.input_allowed = true
	HordeTimer.start()
	horde_timer_active = true
	$GameStartLabel.visible = false
	$GameStartColorRect.visible = false
	LevelSFX.set_stream(ROUND_START)
	LevelSFX.play()
	await get_tree().create_timer(5).timeout # Was 10, but subtracted 3 for previous await
	$ExitZone/CollisionShape2D.disabled = false
	#Player.input_allowed = true

func PrintTime(time: float) -> String:
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	return str("%0*d" % [2, mins]) + ":" + str("%0*d" % [2, secs])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/meta_scenes/main_menu.tscn")

func _process(delta: float) -> void:
	#if zombies_spawned and items_spawned and medical_spawned and weapons_spawned:
		#Player.input_allowed = true
		#print("Input Allowed")
	### After timer ticks down, need to spawn meta zombies, and set their
	### meta_triggered = true and meta_target = Player
	### ALERT: DON'T DO THIS IN _PROCESS ^^^^
	if horde_timer_active:
		Player.TimerLabel.visible = true
		Player.TimerLabel.set_text(str(PrintTime(HordeTimer.get_time_left())))
	if Player.dead and !game_over:
		game_over = true
		GameOver()
	pass

func GameOver() -> void:
	HordeTimer.stop()
	$SpawnTimer.stop()
	Player.TimerLabel.visible = false
	await get_tree().create_timer(2).timeout
	LevelSFX.set_stream(GAME_OVER)
	LevelSFX.play()
	$GameOverLabel.visible = true
	$GameOverLabel.set_text("You now rank among the dead.")
	$GameOverLabel.position = Player.global_position + Vector2(-250,100)
	$DeadColorRect.visible = true
	$DeadColorRect.position = Player.global_position + Vector2(-270,85)
	await get_tree().create_timer(8).timeout
	get_tree().change_scene_to_file("res://scenes/meta_scenes/main_menu.tscn")

func SpawnZombies() -> void:
	var zombie_count := 25
	var zombie_spawns := $ZombieSpawns.get_children()
	var zombie_array := zombie_spawns
	for i in zombie_count:
		var array_length := zombie_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := zombie_array[random_spawn]
		var zombie := ZOMBIE.instantiate()
		add_child(zombie)
		zombie.position = chosen_spawn.global_position
		zombie_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
		pass
		#var random_sfx = randi() % array_length
		#var final_sfx = sfx_array[random_sfx]
	zombies_spawned = true

func SpawnItems() -> void:
	var food_count := 8
	var water_count := 4
	var item_spawns := $ItemSpawns.get_children()
	var item_array := item_spawns
	for i in food_count:
		var array_length := item_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := item_array[random_spawn]
		var food := FOOD.instantiate()
		add_child(food)
		food.position = chosen_spawn.global_position
		item_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
	for i in water_count:
		var array_length := item_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := item_array[random_spawn]
		var water := WATER.instantiate()
		add_child(water)
		water.position = chosen_spawn.global_position
		item_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
	items_spawned = true

func SpawnMedicals() -> void:
	var bandages_count := 4
	var pills_count := 4
	var medical_spawns := $MedicalSpawns.get_children()
	var medical_array := medical_spawns
	for i in bandages_count:
		var array_length := medical_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := medical_array[random_spawn]
		var bandage := BANDAGE.instantiate()
		add_child(bandage)
		bandage.position = chosen_spawn.global_position
		medical_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
	for i in pills_count:
		var array_length := medical_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := medical_array[random_spawn]
		var pills := PILLS.instantiate()
		add_child(pills)
		pills.position = chosen_spawn.global_position
		medical_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
	medical_spawned = true

func SpawnWeapons() -> void:
	var handgun_count := 3
	var rifle_count := 2
	var shotgun_count := 2
	var weapon_spawns := $WeaponSpawns.get_children()
	var weapon_array := weapon_spawns
	for i in handgun_count:
		var array_length := weapon_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := weapon_array[random_spawn]
		var handgun := HANDGUN.instantiate()
		add_child(handgun)
		handgun.position = chosen_spawn.global_position
		weapon_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
	for i in rifle_count:
		var array_length := weapon_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := weapon_array[random_spawn]
		var rifle := RIFLE.instantiate()
		add_child(rifle)
		rifle.position = chosen_spawn.global_position
		weapon_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
	for i in shotgun_count:
		var array_length := weapon_array.size()
		var random_spawn := randi() % array_length
		var chosen_spawn := weapon_array[random_spawn]
		var shotgun := SHOTGUN.instantiate()
		add_child(shotgun)
		shotgun.position = chosen_spawn.global_position
		weapon_array.erase(chosen_spawn)
		await get_tree().create_timer(.05).timeout
	weapons_spawned = true

#func AllowInput() -> void:
	#if zombies_spawned and items_spawned and medical_spawned and weapons_spawned:
		#Player.input_allowed = true
		##print("Input Allowed")
	#else:
		#AllowInput()

func SpawnHorde() -> void:
	var meta_spawns := $MetaSpawns.get_children()
	var meta_array := meta_spawns
	for i in meta_array:
		var zombie := ZOMBIE.instantiate()
		add_child(zombie)
		zombie.meta_triggered = true
		zombie.meta_target = Player
		zombie.position = i.global_position
		await get_tree().create_timer(.05).timeout
	$SpawnTimer.start()

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.food >= 4 and body.water >= 2:
			Global.solo_run_win = true
			get_tree().change_scene_to_file("res://scenes/meta_scenes/main_menu.tscn")
		else:
			print("You need 4 food and 2 water before you exit!")


func _on_horde_timer_timeout() -> void:
	horde_timer_active = false
	Player.TimerLabel.visible = false
	Player.NotificationLabel.visible = true
	LevelSFX.set_stream(HORDE_APPROACHES)
	LevelSFX.play()
	SpawnHorde()
	await get_tree().create_timer(4).timeout
	Player.NotificationLabel.visible = false


func _on_spawn_timer_timeout() -> void:
	SpawnHorde()
