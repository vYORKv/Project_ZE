extends CharacterBody2D

# Zoom should be 1.15 (was previously 1.25)

var client_authority: int

const HANDGUN := preload("res://scenes/items_scenes/handgun.tscn")
const RIFLE := preload("res://scenes/items_scenes/rifle.tscn")
const SHOTGUN := preload("res://scenes/items_scenes/shotgun.tscn")
const EFFECT := preload("res://scenes/objects_scenes/effect_sprite.tscn")
const BANDAGE := preload("res://scenes/items_scenes/bandage.tscn")
const PILLS := preload("res://scenes/items_scenes/pills.tscn")
const FOOD := preload("res://scenes/items_scenes/food.tscn")
const WATER := preload("res://scenes/items_scenes/water.tscn")
#const EFFECT_ANIMATION := preload("res://scenes/objects_scenes/effect_animation.tscn") #NOT USING
#const EFFECT_AUDIO := preload("res://scenes/objects_scenes/effect_audio.tscn") #NOT USING
const BULLET := preload("res://scenes/objects_scenes/bullet.tscn")
#const TEST_ITEM := preload("res://assets/graphics/items/food.png") #Used purely for testing a function

# Audio Files
const HANDGUN_SHOT := preload("res://assets/audio/weapon_sfx/handgun_shot.wav")
const HANDGUN_EMPTY := preload("res://assets/audio/weapon_sfx/handgun_empty.wav")
const HANDGUN_RELOAD := preload("res://assets/audio/weapon_sfx/handgun_reload.wav")
const RIFLE_SHOT := preload("res://assets/audio/weapon_sfx/rifle_shot.wav")
const RIFLE_EMPTY := preload("res://assets/audio/weapon_sfx/rifle_empty.wav")
const RIFLE_RELOAD := preload("res://assets/audio/weapon_sfx/rifle_reload.wav")
const SHOTGUN_SHOT := preload("res://assets/audio/weapon_sfx/shotgun_shot.wav")
const SHOTGUN_EMPTY := preload("res://assets/audio/weapon_sfx/shotgun_empty.wav")
const SHOTGUN_RELOAD := preload("res://assets/audio/weapon_sfx/shotgun_reload.wav")
const SHOTGUN_RACK := preload("res://assets/audio/weapon_sfx/shotgun_rack.wav")
const BULLET_HIT_ACTOR := preload("res://assets/audio/hit_sfx/bullet_hit_actor.wav")
const BAT_HIT := preload("res://assets/audio/hit_sfx/bat_hit.wav")
const BAT_SWING := preload("res://assets/audio/player_sfx/bat_swing.wav")
const FOOTSTEP_LOUD := preload("res://assets/audio/player_sfx/footstep_loud.wav")
const FOOTSTEP_QUIET := preload("res://assets/audio/player_sfx/footstep_quiet.wav")
const TAKE_PILLS := preload("res://assets/audio/player_sfx/take_pills.wav")
const BANDAGING_FULL := preload("res://assets/audio/player_sfx/bandaging_full.wav")
const BANDAGING_3S := preload("res://assets/audio/player_sfx/bandaging_3s.wav")
const DIE_MALE := preload("res://assets/audio/player_sfx/die_male.wav")
const DIE_FEMALE := preload("res://assets/audio/player_sfx/die_female.wav")

# Player Sprites
const YELLOW_POINTER := preload("res://assets/graphics/actors/player/yellow_pointer.png")
const BLUE_POINTER := preload("res://assets/graphics/actors/player/blue_pointer.png")
const BROWN_POINTER := preload("res://assets/graphics/actors/player/brown_pointer.png")
const ORANGE_POINTER := preload("res://assets/graphics/actors/player/orange_pointer.png")
const PINK_POINTER := preload("res://assets/graphics/actors/player/pink_pointer.png")
const PURPLE_POINTER := preload("res://assets/graphics/actors/player/purple_pointer.png")
const RED_POINTER := preload("res://assets/graphics/actors/player/red_pointer.png")
const WHITE_POINTER := preload("res://assets/graphics/actors/player/white_pointer.png")

@onready var Bat := $Bat
@onready var Handgun := $Handgun
@onready var Rifle := $Rifle
@onready var Shotgun := $Shotgun
@onready var ReloadTimer := $ReloadTimer
@onready var ShootTimer := $ShootTimer
@onready var BandageTimer := $BandageTimer
@onready var SwingTimer := $SwingTimer
@onready var GunSFX := $GunSFX
@onready var ReloadSFX := $ReloadSFX
@onready var ShotgunSFX := $ShotgunSFX
@onready var FootstepSFX := $FootstepSFX
@onready var PlayerSFX := $PlayerSFX
@onready var Animate := $AnimationPlayer
@onready var Bandage := $Bandage
@onready var Pills := $Pills
@onready var VisionCone := $VisionCone
# UI Nodes
@onready var PlayerUI := $PlayerUI
@onready var HitpointsLabel := $PlayerUI/HitpointsLabel
@onready var InventoryBG := $PlayerUI/InventoryBG
@onready var InvBat := $PlayerUI/InvBat
@onready var InvHandgun := $PlayerUI/InvHandgun
@onready var InvRifle := $PlayerUI/InvRifle
@onready var InvShotgun := $PlayerUI/InvShotgun
@onready var InvPills := $PlayerUI/InvPills
@onready var InvBandage := $PlayerUI/InvBandage
@onready var Select1 := $PlayerUI/Select1
@onready var Select2 := $PlayerUI/Select2
@onready var Select3 := $PlayerUI/Select3
@onready var Select4 := $PlayerUI/Select4
@onready var WaterBG := $PlayerUI/WaterBG
@onready var FoodBG := $PlayerUI/FoodBG
@onready var WaterCount := $PlayerUI/WaterCount
@onready var FoodCount := $PlayerUI/FoodCount
@onready var Water := $PlayerUI/Water
@onready var Food := $PlayerUI/Food
@onready var Inv1 := $PlayerUI/Inv1
@onready var Inv2 := $PlayerUI/Inv2
@onready var Inv3 := $PlayerUI/Inv3
@onready var Inv4 := $PlayerUI/Inv4
@onready var PillsCount := $PlayerUI/PillsCount
@onready var BandageCount := $PlayerUI/BandageCount
@onready var AmmoCount := $PlayerUI/AmmoCount
@onready var MaxAmmoCount := $PlayerUI/MaxAmmoCount
@onready var BleedingSprite := $PlayerUI/BleedingSprite
@onready var ReloadingSprite := $PlayerUI/ReloadingSprite
@onready var TimerLabel := $PlayerUI/TimerLabel
@onready var NotificationLabel := $PlayerUI/NotificationLabel

var node_toggle := true

const ACCELERATION := 200#2000
const FRICTION := 400#4000
const TURN_SPEED := 0.15
var speed := 100#300

var color := "yellow"
var hitpoints := 100#1000
var bleeding := false
var dead := false

var input_allowed := false
var can_fire := true
var can_swing := true
var bat_contact := false
var longgun_collision := false
var handgun_collision := false
var handgun_max_ammo := 12
var handgun_current_ammo := 12
var rifle_max_ammo := 30
var rifle_current_ammo := 30
var shotgun_max_ammo := 8
var shotgun_current_ammo := 8

var reloading := false
var handgun_reloading := false ## Unused
var rifle_reloading := false ## Unused
var shotgun_reloading := false ## Unused
var bandaging = true

var melee_weapoin := "bat"
var firearm := "none"
var inventory := ["bat", "none", "none", "none"]
var pills := 0
var bandages := 0
var food := 0
var water := 0
var current_wield := "bat"
var inventory_slot := 0

var low_noise_bodies: Array[Object]
var moderate_noise_bodies: Array[Object]
var loud_noise_bodies: Array[Object]

func _ready() -> void:
	print("Player Parent: " + str(get_parent()))
	print("PLayer Tree: " + str(get_tree()))
	#await get_tree().create_timer(1).timeout
	#speed = 100
	pass

func _input(event: InputEvent) -> void:
	if !dead and input_allowed:
		if event.is_action_pressed("walk"):
			speed = 50
		elif event.is_action_released("walk"):
			speed = 100
		if event.is_action_pressed("item_1"):
			inventory_slot = 0
			current_wield = "bat"
			Handgun.visible = false
			Rifle.visible = false
			Shotgun.visible = false
			Pills.visible = false
			Bandage.visible = false
			ReloadSFX.stop()
			ReloadTimer.stop()
			ShotgunSFX.stop()
			PlayerSFX.stop()
			BandageTimer.stop()
			Bat.visible = true
			can_swing = true
			bat_contact = false
		elif event.is_action_pressed("item_2") and inventory[1] != "none":
			inventory_slot = 1
			current_wield = inventory[1]
			Bat.visible = false
			Pills.visible = false
			Bandage.visible = false
			if current_wield == "handgun":
				can_fire = true
				Handgun.visible = true
			elif current_wield == "rifle":
				can_fire = true
				Rifle.visible = true
			elif current_wield == "shotgun":
				can_fire = true
				Shotgun.visible = true
		elif event.is_action_pressed("item_3") and inventory[2] != "none":
			inventory_slot = 2
			Pills.visible = true
			current_wield = "pills"
			Bat.visible = false
			Handgun.visible = false
			Rifle.visible = false
			Shotgun.visible = false
			Bandage.visible = false
			ReloadSFX.stop()
			ReloadTimer.stop()
			ShotgunSFX.stop()
			PlayerSFX.stop()
			BandageTimer.stop()
		elif event.is_action_pressed("item_4") and inventory[3] != "none":
			inventory_slot = 3
			Bandage.visible = true
			current_wield = "bandage"
			Bat.visible = false
			Handgun.visible = false
			Rifle.visible = false
			Shotgun.visible = false
			Pills.visible = false
			ReloadSFX.stop()
			ReloadTimer.stop()
			ShotgunSFX.stop()
			PlayerSFX.stop()
		if event.is_action_pressed("fire"):
			reloading = false
			handgun_reloading = false
			rifle_reloading = false
			shotgun_reloading = false
			ReloadSFX.stop()
			if current_wield == "handgun" and can_fire and !handgun_collision and handgun_current_ammo > 0:
				handgun_current_ammo -= 1
				can_fire = false
				ShootHandgun()
				ShootTimer.set_wait_time(.25)
				ShootTimer.start()
			elif current_wield == "handgun" and can_fire and !handgun_collision and handgun_current_ammo == 0:
				GunSFX.set_stream(HANDGUN_EMPTY)
				GunSFX.set_volume_db(-10.0)
				GunSFX.play()
			elif current_wield == "shotgun" and can_fire and !longgun_collision and shotgun_current_ammo > 0:
				shotgun_current_ammo -= 1
				can_fire = false
				ShootShotgun()
				#ShootTimer.set_wait_time(.75)
				#ShootTimer.start()
			elif current_wield == "shotgun" and can_fire and !longgun_collision and shotgun_current_ammo == 0:
				GunSFX.set_stream(SHOTGUN_EMPTY)
				GunSFX.set_volume_db(-10.0)
				GunSFX.play()
			elif current_wield == "rifle" and can_fire and !longgun_collision and rifle_current_ammo > 0:
				rifle_current_ammo -= 1
				ShootRifle()
			elif current_wield == "rifle" and can_fire and !longgun_collision and rifle_current_ammo == 0:
				GunSFX.set_stream(RIFLE_EMPTY)
				GunSFX.set_volume_db(-10.0)
				GunSFX.play()
			elif current_wield == "bat" and can_swing:
				Animate.play("bat_swing")
				PlayerSFX.set_stream(BAT_SWING)
				PlayerSFX.play()
				can_swing = false
				SwingTimer.start()
			elif current_wield == "bandage" and bleeding:
				PlayerSFX.set_stream(BANDAGING_FULL)
				PlayerSFX.play()
				BandageTimer.start()
				bandaging = true
			elif current_wield == "pills" and hitpoints < 100:
				TakePills()
			else:
				pass
		if event.is_action_released("fire"):
			if current_wield == "bandage":
				PlayerSFX.stop()
				BandageTimer.stop()
				bandaging = false
		if event.is_action_pressed("drop_item"):
			if current_wield == "handgun":
				current_wield = "none"
				inventory[1] = "none"
				Handgun.visible = false
				ReloadSFX.stop()
				ShootTimer.stop() ### May pose a problem
				#GunSFX.stop()
				SpawnWeapon(HANDGUN)
			elif current_wield == "rifle":
				current_wield = "none"
				inventory[1] = "none"
				Rifle.visible = false
				ReloadSFX.stop()
				ShootTimer.stop() ### May pose a problem
				#GunSFX.stop()
				SpawnWeapon(RIFLE)
			elif current_wield == "shotgun":
				current_wield = "none"
				inventory[1] = "none"
				Shotgun.visible = false
				ReloadSFX.stop()
				ShotgunSFX.stop()
				#GunSFX.stop()
				SpawnWeapon(SHOTGUN)
			elif current_wield == "bandage":
				bandages -= 1
				SpawnWeapon(BANDAGE)
				if bandages == 0:
					current_wield = "none"
					inventory[3] = "none"
					Bandage.visible = false
				pass
			elif current_wield == "pills":
				pills -= 1
				SpawnWeapon(PILLS)
				if pills == 0:
					current_wield = "none"
					inventory[2] = "none"
					Pills.visible = false
				pass
			else:
				pass
		if event.is_action_pressed("input_test"):
			#bleeding = true
			#Bleed()
			#print(inventory[0])
			#print(inventory[1])
			#SpawnItemRandom(self.position, 100)
			#var me = self.position
			#MoveSpriteRandom(me, 5)
			#var point = GetRandomPointInCircle(me, 10)
			#print(point)
			#var angle = randf_range(0, 2 * PI)
			#$TestCaster.rotate(angle)
			#CastToRadius($TestCaster)
			#Die()
			#RaycastRadius()
			#CastToRadius()
			#$TestCaster.target_position = point
			pass
		if event.is_action_pressed("reload"):
			if current_wield == "handgun" and handgun_current_ammo < handgun_max_ammo:
				Reload()
			elif current_wield == "rifle" and rifle_current_ammo < rifle_max_ammo:
				Reload()
			elif current_wield == "shotgun" and shotgun_current_ammo < shotgun_max_ammo and !shotgun_reloading:
				shotgun_reloading = true
				ReloadShotgun()
			else:
				pass

func SpawnOnRadius(ITEM) -> void:
	var angle = randf_range(0, TAU)
	var raycast := RayCast2D.new()
	self.add_child(raycast)
	raycast.owner = self
	raycast.set_hit_from_inside(true)
	raycast.set_target_position(Vector2(0, 40))
	raycast.rotate(angle)
	await get_tree().create_timer(.05).timeout ## Necessary to properly return .is_colliding (rotate happens faster than .is_colliding can update) 
	if raycast.is_colliding():
		#print("I collided")
		raycast.queue_free()
		SpawnOnRadius(ITEM)
	else:
		#print(str(ITEM))
		var item_pos := raycast.to_global(raycast.target_position)
		var item: Object = ITEM.instantiate()
		get_parent().add_child(item)
		item.position = item_pos
		raycast.queue_free()

#func PlayerInput() -> void:
	#if Input.is_action_pressed("walk"):
		#speed = 50
	#elif event.is_action_released("walk"):
		#speed = 100
	#if event.is_action_pressed("fire"):
		#handgun_reloading = false
		#rifle_reloading = false
		#shotgun_reloading = false
		#ReloadSFX.stop()
		#if current_wield == "handgun" and can_fire and !handgun_collision and handgun_current_ammo > 0:
			#handgun_current_ammo -= 1
			#can_fire = false
			#ShootHandgun()
			#ShootTimer.set_wait_time(.25)
			#ShootTimer.start()
		#elif current_wield == "handgun" and can_fire and !handgun_collision and handgun_current_ammo == 0:
			#GunSFX.set_stream(HANDGUN_EMPTY)
			#GunSFX.set_volume_db(-10.0)
			#GunSFX.play()
		#elif current_wield == "shotgun" and can_fire and !longgun_collision and shotgun_current_ammo > 0:
			#shotgun_current_ammo -= 1
			#can_fire = false
			#ShootShotgun()
			##ShootTimer.set_wait_time(.75)
			##ShootTimer.start()
		#elif current_wield == "shotgun" and can_fire and !longgun_collision and shotgun_current_ammo == 0:
			#GunSFX.set_stream(SHOTGUN_EMPTY)
			#GunSFX.set_volume_db(-10.0)
			#GunSFX.play()
		#elif current_wield == "rifle" and can_fire and !longgun_collision and rifle_current_ammo > 0:
			#rifle_current_ammo -= 1
			#ShootRifle()
		#elif current_wield == "rifle" and can_fire and !longgun_collision and rifle_current_ammo == 0:
			#GunSFX.set_stream(RIFLE_EMPTY)
			#GunSFX.set_volume_db(-10.0)
			#GunSFX.play()
		#else:
			#pass
	#if event.is_action_pressed("drop_item"):
		#if current_wield == "handgun":
			#current_wield = "none"
			#Handgun.visible = false
			#ReloadSFX.stop()
			#ShootTimer.stop() ### May pose a problem
			##GunSFX.stop()
			#SpawnWeapon(HANDGUN)
		#elif current_wield == "rifle":
			#current_wield = "none"
			#Rifle.visible = false
			#ReloadSFX.stop()
			#ShootTimer.stop() ### May pose a problem
			##GunSFX.stop()
			#SpawnWeapon(RIFLE)
		#elif current_wield == "shotgun":
			#current_wield = "none"
			#Shotgun.visible = false
			#ReloadSFX.stop()
			#ShotgunSFX.stop()
			##GunSFX.stop()
			#SpawnWeapon(SHOTGUN)
		#else:
			#pass
	#if event.is_action_pressed("input_test"):
		#Bleed()
	#if event.is_action_pressed("reload"):
		#if current_wield == "handgun" and handgun_current_ammo < handgun_max_ammo:
			#Reload()
		#elif current_wield == "rifle" and rifle_current_ammo < rifle_max_ammo:
			#Reload()
		#elif current_wield == "shotgun" and shotgun_current_ammo < shotgun_max_ammo:
			#shotgun_reloading = true
			#ReloadShotgun()
		#else:
			#pass

func UILabels() -> void:
	HitpointsLabel.text = "HP: " + str(hitpoints)
	if inventory_slot == 0:
		Select1.visible = true
		Select2.visible = false
		Select3.visible = false
		Select4.visible = false
	elif inventory_slot == 1:
		Select1.visible = false
		Select2.visible = true
		Select3.visible = false
		Select4.visible = false
	elif inventory_slot == 2:
		Select1.visible = false
		Select2.visible = false
		Select3.visible = true
		Select4.visible = false
	elif inventory_slot == 3:
		Select1.visible = false
		Select2.visible = false
		Select3.visible = false
		Select4.visible = true
	if inventory[1] == "none":
		InvHandgun.visible = false
		InvRifle.visible = false
		InvShotgun.visible = false
		AmmoCount.visible = false
		MaxAmmoCount.visible = false
	elif inventory[1] == "handgun":
		InvHandgun.visible = true
		InvRifle.visible = false
		InvShotgun.visible = false
		AmmoCount.visible = true
		AmmoCount.text = str(handgun_current_ammo)
		MaxAmmoCount.visible = true
		MaxAmmoCount.text = "/ " + str(handgun_max_ammo)
	elif inventory[1] == "rifle":
		InvHandgun.visible = false
		InvRifle.visible = true
		InvShotgun.visible = false
		AmmoCount.visible = true
		AmmoCount.text = str(rifle_current_ammo)
		MaxAmmoCount.visible = true
		MaxAmmoCount.text = "/ " + str(rifle_max_ammo)
	elif inventory[1] == "shotgun":
		InvHandgun.visible = false
		InvRifle.visible = false
		InvShotgun.visible = true
		AmmoCount.visible = true
		AmmoCount.text = str(shotgun_current_ammo)
		MaxAmmoCount.visible = true
		MaxAmmoCount.text = "/ " + str(shotgun_max_ammo)
	if inventory[2] == "none":
		InvPills.visible = false
		PillsCount.visible = false
	elif inventory[2] == "pills":
		InvPills.visible = true
		PillsCount.visible = true
		PillsCount.text = "x" + str(pills)
	if inventory[3] == "none":
		InvBandage.visible = false
		BandageCount.visible = false
	elif inventory[3] == "bandage":
		InvBandage.visible = true
		BandageCount.visible = true
		BandageCount.text = "x" + str(bandages)
	WaterCount.text = "x" + str(water)
	FoodCount.text = "x" + str(food)
	if bleeding:
		BleedingSprite.visible = true
		BleedingSprite.play("bleeding_anim")
	else:
		BleedingSprite.visible = false
		BleedingSprite.stop()
	if reloading:
		ReloadingSprite.visible = true
		ReloadingSprite.play("reloading_anim")
	else:
		ReloadingSprite.visible = false
		ReloadingSprite.stop()

func _physics_process(delta: float) -> void:
	UILabels()
	if !dead and input_allowed:
		WeaponCollision()
		Movement(delta)

func Movement(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	#var direction := (mouse_position - self.position).normalized()
	#print(direction)
	#WeaponCollision()
	# Literal movement
	var input_vector := Vector2.ZERO
	LookAtMouse()
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, ACCELERATION * delta)
		if speed == 100:
			MakeNoise("low")
			PlayFootstep(FOOTSTEP_LOUD, "loud")
		elif speed == 50:
			PlayFootstep(FOOTSTEP_QUIET, "quiet")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		FootstepSFX.stop()
	move_and_slide()

func PlayFootstep(sfx: AudioStream, volume: String) -> void:
	if !FootstepSFX.is_playing():
		FootstepSFX.set_stream(sfx)
		if volume == "loud":
			FootstepSFX.set_max_distance(500)
		elif volume == "quiet":
			FootstepSFX.set_max_distance(100)
		FootstepSFX.play()

func MakeNoise(level: String) -> void:
	if level == "low":
		for i in low_noise_bodies:
			i.HearNoise(self)
	elif level == "moderate":
		for i in moderate_noise_bodies:
			i.HearNoise(self)
	elif level == "loud":
		for i in loud_noise_bodies:
			i.HearNoise(self)

func ShootHandgun() -> void:
	MakeNoise("moderate")
	GunSFX.set_stream(HANDGUN_SHOT)
	GunSFX.set_volume_db(0.0)
	GunSFX.set_max_distance(1500.00)
	GunSFX.play()
	var bullet := BULLET.instantiate()
	bullet.type = "handgun"
	get_parent().add_child(bullet)
	bullet.position = $Handgun/Barrel.global_position
	bullet.look_at($Handgun/Aim.global_position)
	bullet.velocity = $Handgun/Aim.global_position - bullet.position

func ShootRifle() -> void:
	MakeNoise("loud")
	GunSFX.set_stream(RIFLE_SHOT)
	GunSFX.set_volume_db(0.0)
	GunSFX.set_max_distance(3000.0)
	GunSFX.play()
	var bullet := BULLET.instantiate()
	bullet.type = "rifle"
	get_parent().add_child(bullet)
	bullet.position = $Rifle/Barrel.global_position
	bullet.look_at($Rifle/Aim.global_position)
	bullet.velocity = $Rifle/Aim.global_position - bullet.position

func ShootShotgun() -> void:
	MakeNoise("loud")
	GunSFX.set_stream(SHOTGUN_SHOT)
	GunSFX.set_volume_db(0.0)
	GunSFX.set_max_distance(3000.0)
	ShotgunSFX.set_stream(SHOTGUN_RACK)
	GunSFX.play()
	var bullet1 := BULLET.instantiate()
	var bullet2 := BULLET.instantiate()
	var bullet3 := BULLET.instantiate()
	var bullet4 := BULLET.instantiate()
	var bullet5 := BULLET.instantiate()
	bullet1.type = "shotgun"
	bullet2.type = "shotgun"
	bullet3.type = "shotgun"
	bullet4.type = "shotgun"
	bullet5.type = "shotgun"
	get_parent().add_child(bullet1)
	get_parent().add_child(bullet2)
	get_parent().add_child(bullet3)
	get_parent().add_child(bullet4)
	get_parent().add_child(bullet5)
	bullet1.position = $Shotgun/Barrel.global_position
	bullet1.look_at($Shotgun/Aim1.global_position)
	bullet1.velocity = $Shotgun/Aim1.global_position - bullet1.position
	bullet2.position = $Shotgun/Barrel.global_position
	bullet2.look_at($Shotgun/Aim2.global_position)
	bullet2.velocity = $Shotgun/Aim2.global_position - bullet2.position
	bullet3.position = $Shotgun/Barrel.global_position
	bullet3.look_at($Shotgun/Aim3.global_position)
	bullet3.velocity = $Shotgun/Aim3.global_position - bullet3.position
	bullet4.position = $Shotgun/Barrel.global_position
	bullet4.look_at($Shotgun/Aim4.global_position)
	bullet4.velocity = $Shotgun/Aim4.global_position - bullet4.position
	bullet5.position = $Shotgun/Barrel.global_position
	bullet5.look_at($Shotgun/Aim5.global_position)
	bullet5.velocity = $Shotgun/Aim5.global_position - bullet5.position
	await get_tree().create_timer(.5).timeout
	if current_wield == "shotgun":
		ShotgunSFX.play()
		await ShotgunSFX.finished
		can_fire = true

func Reload() -> void:
	reloading = true
	if current_wield == "handgun":
		ReloadSFX.set_stream(HANDGUN_RELOAD)
		ReloadSFX.play()
		await ReloadSFX.finished
		reloading = false
		handgun_current_ammo = handgun_max_ammo
	elif current_wield == "rifle":
		ReloadSFX.set_stream(RIFLE_RELOAD)
		ReloadSFX.play()
		await ReloadSFX.finished
		reloading = false
		rifle_current_ammo = rifle_max_ammo

func ReloadShotgun() -> void:
	reloading = false
	ReloadSFX.set_stream(SHOTGUN_RELOAD)
	ReloadSFX.play()
	await ReloadSFX.finished
	if shotgun_reloading:
		shotgun_current_ammo += 1
	if shotgun_current_ammo < shotgun_max_ammo and shotgun_reloading:
		ReloadShotgun()
	elif shotgun_current_ammo == shotgun_max_ammo and shotgun_reloading:
		ReloadSFX.set_stream(SHOTGUN_RACK)
		ReloadSFX.play()
		reloading = false
		shotgun_reloading = false

func Hit(damage: int) -> void:
	PlayerSFX.set_stream(BULLET_HIT_ACTOR)
	PlayerSFX.play()
	hitpoints -= damage
	if hitpoints <= 0:
		Die()

func Damage(damage: int) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		Die()

func Bleed() -> void:
	if bleeding:
		var blood := EFFECT.instantiate()
		get_parent().add_child(blood)
		blood.SetSprite(blood.BLOOD_SPLATTER)
		blood.set_z_index(3)
		blood.position = self.global_position
		Damage(10)
		await get_tree().create_timer(3).timeout
		Bleed()

func UseBandage() -> void:
	PlayerSFX.stop()
	bandages -= 1
	if bandages == 0:
		Bandage.visible = false
		inventory[3] = "none"
		current_wield = "none"
	bandaging = false
	bleeding = false
	if hitpoints <= 75:
		hitpoints += 25
	else:
		var missing_hp = 100 - hitpoints
		hitpoints += missing_hp

func TakePills() -> void:
	PlayerSFX.set_stream(TAKE_PILLS)
	PlayerSFX.play()
	pills -= 1
	if pills == 0:
		Pills.visible = false
		inventory[2] = "none"
		current_wield = "none"
	if hitpoints <= 50:
		hitpoints += 50
	else:
		var missing_hp = 100 - hitpoints
		hitpoints += missing_hp

func DropAllItems() -> void:
	if inventory[1] != "none":
		if inventory[1] == "handgun":
			SpawnOnRadius(HANDGUN)
		elif inventory[1] == "rifle":
			SpawnOnRadius(RIFLE)
		elif inventory[1] == "shotgun":
			SpawnOnRadius(SHOTGUN)
	if pills > 0:
		for i in pills:
			SpawnOnRadius(PILLS)
			pills -= 1
	if bandages > 0: 
		for i in bandages:
			SpawnOnRadius(BANDAGE)
			bandages -= 1
	if food > 0:
		for i in food:
			SpawnOnRadius(FOOD)
			food -= 1
	if water > 0:
		for i in water:
			SpawnOnRadius(WATER)
			water -= 1

func Die() -> void:
	bleeding = false
	bandaging = false
	dead = true
	Bat.visible = false
	Handgun.visible = false
	Rifle.visible = false
	Shotgun.visible = false
	Pills.visible = false
	Bandage.visible = false
	PlayerSFX.stop()
	var corpse := EFFECT.instantiate()
	get_parent().add_child(corpse)
	corpse.CorpseSprite(color)
	corpse.position = self.global_position
	# ALL visible/disable code #
	if color == "pink":
		PlayerSFX.set_stream(DIE_FEMALE)
	else:
		PlayerSFX.set_stream(DIE_MALE)
	PlayerSFX.play()
	NodeToggles()
	DropAllItems()
	VisionCone.visible = false
	$SpectatorVision.visible = true
	# ALL visible/disable code #

func NodeToggles() -> void:
	if node_toggle:
		PlayerUI.visible = false
		$Sprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		$NoiseLow/CollisionShape2D.set_deferred("disabled", true)
		$NoiseModerate/CollisionShape2D.set_deferred("disabled", true)
		$NoiseLoud/CollisionShape2D.set_deferred("disabled", true)
		Handgun.visible = false
		Rifle.visible = false
		Shotgun.visible = false
		$GunCollision.set_deferred("enabled", false)
		$HandgunCollision.set_deferred("enabled", false)
		FootstepSFX.stop()
		ReloadSFX.stop()
		ShotgunSFX.stop()
	elif !node_toggle:
		PlayerUI.visible = true
		$Sprite2D.visible = true
		$CollisionShape2D.set_deferred("disabled", false)
		$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
		$NoiseLow/CollisionShape2D.set_deferred("disabled", false)
		$NoiseModerate/CollisionShape2D.set_deferred("disabled", false)
		$NoiseLoud/CollisionShape2D.set_deferred("disabled", false)
		Handgun.visible = true
		Rifle.visible = true
		Shotgun.visible = true
		$GunCollision.set_deferred("enabled", true)
		$HandgunCollision.set_deferred("enabled", true)

func SpawnWeapon(WeaponScene: Object) -> void: ### MIGHT NEED TO KEEP ###
	var weapon: Object = WeaponScene.instantiate()
	get_parent().add_child(weapon)
	if WeaponScene == HANDGUN:
		weapon.current_ammo = handgun_current_ammo
	elif WeaponScene == RIFLE:
		weapon.current_ammo = rifle_current_ammo
	elif WeaponScene == SHOTGUN:
		weapon.current_ammo = shotgun_current_ammo
	weapon.position = self.global_position

func SpawnItem(ItemScene: Object) -> void:
	var item: Object = ItemScene.instantiate()
	get_parent().add_child(item)
	item.position = self.global_position

func LookAtMouse() -> void:
	var v := get_global_mouse_position() - self.global_position
	var angle := v.angle()
	var r := global_rotation
	global_rotation = lerp_angle(r, angle, TURN_SPEED)

func WeaponCollision() -> void:
	if $GunCollision.is_colliding():
		longgun_collision = true
		Rifle.set_position(Vector2(19.0, 0.0))
		Rifle.set_rotation_degrees(20)
		Shotgun.set_position(Vector2(19.0, 0.0))
		Shotgun.set_rotation_degrees(20)
	else:
		longgun_collision = false
		Rifle.set_position(Vector2(20.0, 10.0))
		Rifle.set_rotation_degrees(85)
		Shotgun.set_position(Vector2(20.0, 10.0))
		Shotgun.set_rotation_degrees(85)
	if $HandgunCollision.is_colliding():
		handgun_collision = true
		Handgun.set_position(Vector2(17.0, 5.0))
		Handgun.set_rotation_degrees(30)
	else:
		handgun_collision = false
		Handgun.set_position(Vector2(17.0, 10.0))
		Handgun.set_rotation_degrees(85)

func _on_shoot_timer_timeout() -> void:
	can_fire = true

func _on_noise_low_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombies"):
		low_noise_bodies.push_back(body)

func _on_noise_low_body_exited(body: Node2D) -> void:
	low_noise_bodies.erase(body)

func _on_noise_moderate_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombies"):
		moderate_noise_bodies.push_back(body)

func _on_noise_moderate_body_exited(body: Node2D) -> void:
	moderate_noise_bodies.erase(body)

func _on_noise_loud_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombies"):
		loud_noise_bodies.push_back(body)

func _on_noise_loud_body_exited(body: Node2D) -> void:
	loud_noise_bodies.erase(body)

func _on_bandage_timer_timeout() -> void:
	UseBandage()

func _on_bat_hitbox_area_entered(area: Area2D) -> void:
	var victim = area.get_parent()
	if !bat_contact and (victim.is_in_group("player") or victim.is_in_group("zombies")):
		#$BatHitbox/CollisionPolygon2D.disabled = true
		print(victim)
		bat_contact = true
		PlayerSFX.set_stream(BAT_HIT)
		PlayerSFX.play()
		#Animate.stop()
		victim.Hit(25)
		#$BatHitbox/CollisionPolygon2D.disabled = true

func _on_swing_timer_timeout() -> void:
	can_swing = true
	bat_contact = false
