extends CharacterBody2D

const EFFECT := preload("res://scenes/objects_scenes/effect_sprite.tscn")
const EFFECT_AUDIO := preload("res://scenes/objects_scenes/effect_audio.tscn")
const BULLET_HIT_ACTOR := preload("res://assets/audio/hit_sfx/bullet_hit_actor.wav")

### Audio SFX
const AGGRO_1 := preload("res://assets/audio/zombie_sfx/aggro/aggro_1.wav")
const AGGRO_2 := preload("res://assets/audio/zombie_sfx/aggro/aggro_2.wav")
const AGGRO_3 := preload("res://assets/audio/zombie_sfx/aggro/aggro_3.wav")
const AGGRO_4 := preload("res://assets/audio/zombie_sfx/aggro/aggro_4.wav")
const AGGRO_5 := preload("res://assets/audio/zombie_sfx/aggro/aggro_5.wav")
const AGGRO_6 := preload("res://assets/audio/zombie_sfx/aggro/aggro_6.wav")
const AGGRO_7 := preload("res://assets/audio/zombie_sfx/aggro/aggro_7.wav")
const AGGRO_8 := preload("res://assets/audio/zombie_sfx/aggro/aggro_8.wav")
const AGGRO_9 := preload("res://assets/audio/zombie_sfx/aggro/aggro_9.wav")
const HUNTING_1 := preload("res://assets/audio/zombie_sfx/hunting/hunting_1.wav")
const HUNTING_2 := preload("res://assets/audio/zombie_sfx/hunting/hunting_2.wav")
const HUNTING_3 := preload("res://assets/audio/zombie_sfx/hunting/hunting_3.wav")
const HUNTING_4 := preload("res://assets/audio/zombie_sfx/hunting/hunting_4.wav")
const IDLE_1 := preload("res://assets/audio/zombie_sfx/idle/idle_1.wav")
const IDLE_2 := preload("res://assets/audio/zombie_sfx/idle/idle_2.wav")
const IDLE_3 := preload("res://assets/audio/zombie_sfx/idle/idle_3.wav")
const IDLE_4 := preload("res://assets/audio/zombie_sfx/idle/idle_4.wav")
const IDLE_5 := preload("res://assets/audio/zombie_sfx/idle/idle_5.wav")
const IDLE_6 := preload("res://assets/audio/zombie_sfx/idle/idle_6.wav")
const IDLE_7 := preload("res://assets/audio/zombie_sfx/idle/idle_7.wav")
const BITE_1 := preload("res://assets/audio/zombie_sfx/bite_1.wav")
const BITE_2 := preload("res://assets/audio/zombie_sfx/bite_2.wav")


@onready var OneShotSFX := $OneShotSFX
@onready var LoopingSFX := $LoopingSFX
@onready var NavAgent := $NavigationAgent2D
@onready var LastTargetTimer := $LastTargetTimer
@onready var PointMoveTimer := $PointMoveTimer
@onready var BiteTimer := $BiteTimer
@onready var AudioTimer := $AudioTimer

const TURN_SPEED := 4
const ACCELERATION := 200
const FRICTION := 400
var speed := 80
var generated_speed := 80
var hitpoints := 60
var bleeding := false
var aggro := false
var hunting := false
var moaning := false
var can_bite := true

var current_target: Object
var current_target_last_position: Vector2
var last_target: Object
var last_position: Vector2
var last_timer_inactive := true
var last_timer_finished := false
var point_timer_inactive := true
var point_timer_finished := false
var meta_triggered := false
var meta_target: Object

enum {
	IDLE,
	SEARCH,
	PURSUE,
	CHECK_LAST,
	CHECK_SOUND,
	MOB_MENTALITY,
	META
}

var aggro_sfx := [AGGRO_1, AGGRO_2, AGGRO_3, AGGRO_4, AGGRO_5, AGGRO_6, AGGRO_7, AGGRO_8, AGGRO_9]
var hunting_sfx := [HUNTING_1, HUNTING_2, HUNTING_3, HUNTING_4]
var idle_sfx := [IDLE_1, IDLE_2, IDLE_3, IDLE_4, IDLE_5, IDLE_6, IDLE_7]
var bite_sfx := [BITE_1, BITE_2]

var state := IDLE
#var casting_rays := false
var player_in_range := false
var players_in_range: Array[Object]
#var players_can_see := []
var player_in_sight := false
var players_in_sight: Array[Object]
var rays: Array[Object]
var attack_range: Array[Object]
var heard_noise := false
var noise_heard: Vector2
var mob: Array[Object]
var mob_position: Vector2
var mob_mentality := false
var alerted_mob := false

var body_node: Object
var body_pos: Vector2

func _ready() -> void:
	GenerateSpeed()
	RandomRotate()
	#FlashCollisions()
	#LastTargetTimer.start()
	pass

func GenerateSpeed() -> void:
	var rn := randi() % 4
	#print(seed)
	if rn == 0:
		generated_speed = 80
	elif rn == 1:
		generated_speed = 85
	elif rn == 2:
		generated_speed = 90
	elif rn == 3:
		generated_speed = 95
	speed = generated_speed

func RandomRotate() -> void:
	var rn := randi() % 180
	self.rotate(rn)

func FlashCollisions() -> void:
	await get_tree().create_timer(2).timeout
	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", false)

func RandomPosition(center: Vector2, distance: float) -> Vector2: ### NOT NEEDED ###
	var random_x := randf() * distance * 2 - distance
	var random_y := randf() * distance * 2 - distance
	return Vector2(center.x + random_x, center.y + random_y)

func PlayLoopingSFX(sfx_array: Array) -> void:
	#var array_length = sfx_array.size()
	#var random_sfx = randi() % array_length
	#var final_sfx = sfx_array[random_sfx]
	var random_sfx = sfx_array.pick_random()
	#print(final_sfx)
	LoopingSFX.set_stream(random_sfx)
	LoopingSFX.play()

func PlayOneShotSFX(sfx_array: Array) -> void:
	#var array_length = sfx_array.size()
	#var random_sfx = randi() % array_length
	#var final_sfx = sfx_array[random_sfx]
	var random_sfx = sfx_array.pick_random()
	OneShotSFX.set_stream(random_sfx)
	OneShotSFX.play()

func _physics_process(delta: float) -> void:
	#if state == IDLE:
		#print(str(self) + "State: IDLE")
	#elif state == SEARCH:
		#print(str(self) + "State: SEARCH")
	#elif state == PURSUE:
		#print(str(self) + "State: PURSUE")
	#elif state == CHECK_LAST:
		#print(str(self) + "State: CHECK_LAST")
	#elif state == CHECK_SOUND:
		#print(str(self) + "State: CHECK_SOUND")
	#elif state == MOB_MENTALITY:
		#print(str(self) + "State: MOB_MENTALITY")
	
	#print(last_target.is_valid())
	
	if moaning:
		pass
		if !LoopingSFX.is_playing():
			PlayLoopingSFX(idle_sfx)
	elif hunting:
		pass
		if !LoopingSFX.is_playing():
			PlayLoopingSFX(hunting_sfx)
	elif aggro:
		pass
		if !LoopingSFX.is_playing():
			PlayLoopingSFX(aggro_sfx)
	
	#print(moaning)
	#print(mob)
	#print(heard_noise)
	#print(point_timer_inactive)
	#print(typeof(last_target))
	#print("Players in sight: " + str(players_in_sight))
	#DrawRay()
	#print(last_target)
	#CheckDistance()
	#print(speed)
	#print(current_target)
	#print("State: " + str(state))
	#print("LastTargetTimer: " + str(LastTargetTimer.get_time_left()))
	#print("PointMoveTimer: " + str(PointMoveTimer.get_time_left()))
	#if LastTargetTimer.is_stopped():
		#print("Timer Stopped")
	#else:
		#print("Timer Running")
	#print("Current Target: " + str(current_target))
	#print("Last Target: " + str(last_target))
	#print("Player in sight: " + str(player_in_sight))
	if meta_triggered:
		state = META
	elif player_in_sight:
		state = PURSUE
	elif last_target != null:
		if !last_target.dead:
			state = CHECK_LAST
	elif heard_noise:
		state = CHECK_SOUND
	elif mob_mentality:
		state = MOB_MENTALITY
	#elif last_target != null:
		#state = CHECK_LAST
	match state:
		IDLE:
			#print(str(self) + "Entered Idle")
			DrawRay()
			CheckDistance()
			if !moaning:
				LoopingSFX.stop()
			hunting = false
			aggro = false
			moaning = true
			#if !moaning:
				##print("Entering first moan")
				#hunting = false
				#aggro = false
				##print("Rotate")
				##RandomRotate()
				#PlayLoopingSFX(idle_sfx)
				#moaning = true
			#else:
				##print("Entering second moan")
				#if !LoopingSFX.is_playing():
					##print("Executing second moan")
					#PlayLoopingSFX(idle_sfx)
			#NavAgent.target_position = global_position
			#if heard_noise:
				#state = CHECK_SOUND
			#pass
		SEARCH:
			#print("Entered Cast")
			DrawRay()
			CheckDistance()
			if heard_noise:
				state = CHECK_SOUND
		PURSUE:
			#print(str(self) + "Entered Pursue")
			DrawRay()
			CheckDistance()
			heard_noise = false
			if !aggro:
				LoopingSFX.stop()
			hunting = false
			moaning = false
			aggro = true
			#if !aggro:
				#LoopingSFX.stop()
				####Stop moaning sfx
				#hunting = false
				#moaning = false
				##print("aggro")
				#PlayLoopingSFX(aggro_sfx)
				#aggro = true
			#else:
				#if !LoopingSFX.is_playing():
					#PlayLoopingSFX(aggro_sfx)
			#if !alerted_mob:
				#AlertMob(current_target.global_position)
			if current_target: #if current_target (was body_node)
				#print("Pursue Branch 1")
				#look_at(body_node.position)
				#AlertMob(current_target.global_position)
				NavAgent.target_position = current_target.global_position
			#elif last_target != null:
				#aggro = false
				#state = CHECK_LAST #current_target.global_position (was body_node.global_position)
			else: 
				aggro = false
				state = CHECK_LAST
				
				#print("Exiting Pursue")
				#print("Pursue Branch 2")
				#AlertMob(last_target.global_position)
				#LoopingSFX.stop()
				
				#aggro = false
				#state = IDLE
				
				#NavAgent.target_position = last_target.global_position
			#if NavAgent.is_navigation_finished():
				#print("REACHED FINISHED")
				#return
			var current_agent_position := global_position
			var next_path_position: Vector2 = NavAgent.get_next_path_position()
			var new_velocity := current_agent_position.direction_to(next_path_position) * speed
			
			if !attack_range.is_empty():
				NavAgent.avoidance_enabled = false
			else:
				NavAgent.avoidance_enabled = true
			#print(NavAgent.avoidance_enabled)
			if NavAgent.avoidance_enabled:
				NavAgent.set_velocity(new_velocity)
			else:
				velocity = new_velocity
			#look_at(next_path_position)
			TurnSpeed(next_path_position, delta)
			move_and_slide()
		CHECK_LAST:
			#print(str(self) + "Entered Check Last")
			DrawRay()
			CheckDistance()
			if !hunting:
				LoopingSFX.stop()
			moaning = false
			aggro = false
			hunting = true
			#if !hunting:
				#LoopingSFX.stop()
				#moaning = false
				#aggro = false
				#PlayLoopingSFX(hunting_sfx)
				#hunting = true
			#else:
				#if !LoopingSFX.is_playing():
					#PlayLoopingSFX(hunting_sfx)
			if current_target:
				#print("First Branch")
				LastTargetTimer.stop()
				last_timer_inactive = true
				#PointMoveTimer.stop()
				#point_timer_inactive = true
				###Stop Hunting SFX
				#hunting = false
				state = PURSUE
			if last_target.dead:
				#print("HE DEAD")
				last_target = null
				state = IDLE
			#else:
				#NavAgent.target_position = last_target.global_position
			#elif heard_noise:
				#state = CHECK_SOUND
			elif last_timer_inactive:
				#print("Second Branch")
				last_timer_inactive = false
				LastTargetTimer.start()
				
			elif !last_timer_finished:
				#print("Final Branch")
				NavAgent.target_position = last_target.global_position
			elif last_timer_finished:
				#print("Timer Finished Branch")
				last_timer_inactive = true
				last_timer_finished = false
				last_target = null
				###Stop hunting sfx
				hunting = false
				#print("Moving to IDLE")
				state = IDLE
				
			#if NavAgent.is_navigation_finished():
				#LoopingSFX.stop()
				#hunting = false
				#state = IDLE
				#print("REACHED FINISHED")
				#return
			var current_agent_position := global_position
			var next_path_position: Vector2 = NavAgent.get_next_path_position()
			var new_velocity := current_agent_position.direction_to(next_path_position) * speed
			
			if !attack_range.is_empty():
				NavAgent.avoidance_enabled = false
			else:
				NavAgent.avoidance_enabled = true
			#print(NavAgent.avoidance_enabled)
			if NavAgent.avoidance_enabled:
				NavAgent.set_velocity(new_velocity)
			else:
				velocity = new_velocity
			#look_at(next_path_position)
			TurnSpeed(next_path_position, delta)
			move_and_slide()
		CHECK_SOUND:
			#print(str(self) + "Entered Check Sound")
			DrawRay()
			CheckDistance()
			#print("Made it here")
			if !hunting:
				LoopingSFX.stop()
			moaning = false
			aggro = false
			hunting = true
			#if !hunting:
				#LoopingSFX.stop()
				#moaning = false
				#aggro = false
				#PlayLoopingSFX(hunting_sfx)
				#hunting = true
			#else:
				#if !LoopingSFX.is_playing():
					#PlayLoopingSFX(hunting_sfx)
			if current_target:
				#print("First Branch")
				LastTargetTimer.stop()
				last_timer_inactive = true
				PointMoveTimer.stop()
				point_timer_inactive = true
				heard_noise = false
				###Stop Hunting SFX
				#hunting = false
				state = PURSUE
			#else:
				#NavAgent.target_position = noise_heard
			#elif heard_noise:
				#state = CHECK_SOUND
			elif point_timer_inactive:
				#print("Second Branch")
				PointMoveTimer.start()
				point_timer_inactive = false
			elif !point_timer_finished:
				#print("Final Branch")
				#print(noise_heard)
				NavAgent.target_position = noise_heard
			elif point_timer_finished:
				#print(str(self) + "Timer Finished Branch")
				point_timer_inactive = true
				point_timer_finished = false
				heard_noise = false
				###Stop hunting sfx
				hunting = false
				#noise_heard = null
				#print("Moving to IDLE")
				state = IDLE
				
			if NavAgent.is_navigation_finished():
				#print("Nav finished")
				###Stop hunting sfx
				hunting = false
				#heard_noise = false
				state = IDLE
				#for i in mob:
					#i.state = IDLE
				#print("REACHED FINISHED")
				#return
			var current_agent_position := global_position
			var next_path_position: Vector2 = NavAgent.get_next_path_position()
			var new_velocity := current_agent_position.direction_to(next_path_position) * speed
			
			if !attack_range.is_empty():
				NavAgent.avoidance_enabled = false
			else:
				NavAgent.avoidance_enabled = true
			#print(NavAgent.avoidance_enabled)
			if NavAgent.avoidance_enabled:
				NavAgent.set_velocity(new_velocity)
			else:
				velocity = new_velocity
			#look_at(next_path_position)
			TurnSpeed(next_path_position, delta)
			move_and_slide()
		MOB_MENTALITY:
			DrawRay()
			CheckDistance()
			#NavAgent.set_target_desired_distance(32) 
			if current_target:
				#print("First Branch")
				LastTargetTimer.stop()
				last_timer_inactive = true
				PointMoveTimer.stop()
				point_timer_inactive = true
				mob_mentality = false
				state = PURSUE
			#else:
				#NavAgent.target_position = mob_position
			#elif heard_noise:
				#state = CHECK_SOUND
			
			
			elif point_timer_inactive:
				#print("Second Branch")
				PointMoveTimer.start()
				point_timer_inactive = false
			elif !point_timer_finished:
				#print("Final Branch")
				NavAgent.target_position = mob_position
			elif point_timer_finished:
				#print("Timer Finished Branch")
				point_timer_inactive = true
				point_timer_finished = false
				mob_mentality = false
				#last_target = null
				#print("Moving to IDLE")
				state = IDLE
				
			if NavAgent.is_navigation_finished():
				
				state = IDLE
				#print("REACHED FINISHED")
				#return
			var current_agent_position := global_position
			var next_path_position: Vector2 = NavAgent.get_next_path_position()
			var new_velocity := current_agent_position.direction_to(next_path_position) * speed
			
			if !attack_range.is_empty():
				NavAgent.avoidance_enabled = false
			else:
				NavAgent.avoidance_enabled = true
			#print(NavAgent.avoidance_enabled)
			if NavAgent.avoidance_enabled:
				NavAgent.set_velocity(new_velocity)
			else:
				velocity = new_velocity
			#look_at(next_path_position)
			TurnSpeed(next_path_position, delta)
			move_and_slide()
		META:
			heard_noise = false
			if !aggro:
				LoopingSFX.stop()
			hunting = false
			moaning = false
			aggro = true
			#if meta_target:
				#NavAgent.target_position = meta_target.global_position
			#else: 
				#aggro = false
				#state = IDLE
			if meta_target.dead:
				meta_triggered = false
				aggro = false
				state = IDLE
			NavAgent.target_position = meta_target.global_position
			var current_agent_position := global_position
			var next_path_position: Vector2 = NavAgent.get_next_path_position()
			var new_velocity := current_agent_position.direction_to(next_path_position) * speed
			if !attack_range.is_empty():
				NavAgent.avoidance_enabled = false
			else:
				NavAgent.avoidance_enabled = true
			if NavAgent.avoidance_enabled:
				NavAgent.set_velocity(new_velocity)
			else:
				velocity = new_velocity
			TurnSpeed(next_path_position, delta)
			move_and_slide()
	
	######## BLOCK OUT #######
	##print(state)
	#if players_in_sight:
		#state = PURSUE
	#
	#if current_target != null:
		#last_target = current_target
		#current_target_last_position = current_target.position
		##current_target_last_position = (current_target.global_position - self.position).normalized()
	#
	#if current_target_last_position != null:
		#state = CHECK_LAST
	#
	#match state:
		#IDLE: 
			#pass
		#CAST:
			#DrawRay()
			#CheckDistance()
		#AIM:
			#DrawRay()
			#CheckDistance()
			#if current_target == null:
				#state = CAST
			#else:
				##look_at(current_target.position)
				#TurnSpeed(delta)
		#PURSUE:
			#DrawRay()
			#CheckDistance()
			#if players_in_sight.is_empty() and last_target != null:
				#state = CHECK_LAST
				###state = CAST
				##print("Going to last known position...")
				##MakePath(current_target_last_position)
				##var dir := to_local(NavAgent.target_position).normalized()
				###velocity = velocity.move_toward(current_target_last_position * speed, ACCELERATION * delta)
				##velocity = dir * speed
				##move_and_slide()
			#elif current_target == null:
				#state = CAST
			#elif current_target != null:
				#print("Pursuing...")
				#var ct_pos = current_target.position
				#MakePath(ct_pos)
				#TurnSpeed(delta)
				##look_at(current_target)
				##var target_pos = (current_target.position - self.position).normalized()
				#var dir := to_local(NavAgent.target_position).normalized()
				#velocity = dir * speed
				##velocity = velocity.move_toward(dir * speed, ACCELERATION * delta)
				#move_and_slide()
		#CHECK_LAST:
			##velocity = velocity.move_toward(last_position * speed, ACCELERATION * delta)
			##move_and_slide()
			##if velocity == Vector2.ZERO:
				##state = CAST
			#print("Going to last known position...")
			#MakePath(current_target_last_position)
			#var dir := to_local(NavAgent.target_position).normalized()
			##velocity = velocity.move_toward(current_target_last_position * speed, ACCELERATION * delta)
			#velocity = dir * speed
			#move_and_slide()
			#if self.position == current_target_last_position:
				#print("Made it!")
	######## BLOCK OUT #######
	
	#print(players_in_sight)
	#print(current_target)
	#print(player_in_range)
	#if player_in_sight:
		#state = AIM
	#elif player_in_range:
		#state = CAST
	
	#if player_in_range:
		#DrawRay()
		#CheckDistance()
	#if players_in_sight:
		#LookAtMouse()
		#var target_pos = current_target.global_position
		#var direction = target_pos - self.position
		#look_at(current_target.position)
		#look_at(target_pos)
	#print(current_target)
	
	#if current_target != null:
		#print(current_target)
		##var direction = current_target.position - self.global_position
		#look_at(current_target.position)
	#print(current_target)
	#print(players_in_sight)
	#print(players_can_see)
	#if casting_rays:
		#CastRays()
	pass

#func _process(delta: float) -> void:
	#if player_in_range:
		#DrawRay()
		#CheckDistance()
	#print(current_target)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		##print(players_in_sight)
		#
		##var blood := EFFECT.instantiate()
		##get_parent().add_child(blood)
		##blood.SetSprite(blood.BLOOD_SPLATTER_Z)
		##blood.set_z_index(3)
		##blood.position = current_target.global_position
		#
		#RandomRotate()
		#
		##for i in players_in_sight:
			##var distance := self.position.distance_to(i.position)
			##print(str(i) + " is this far: " + str(distance))
			###var distance = self.position - i.position
			###print(str(i) + " is this far: " + str(distance))

func Bite(victim: Object) -> void:
	PlayOneShotSFX(bite_sfx)
	var bleed_chance = randi() % 4
	#print(bleed_chance)
	if bleed_chance == 3 and !victim.bleeding:
		#print("Start Bleed")
		victim.bleeding = true
		victim.Damage(5)
		victim.Bleed()
	else:
		#print("Passed")
		victim.Damage(10)
	can_bite = false
	$BiteHitBox/CollisionPolygon2D.set_deferred("disabled", true)
	BiteTimer.start()

func MakePath(path: Vector2) -> void: ### CURRENTLY NOT BEING USED ###
	NavAgent.target_position = path

func TurnSpeed(turn_point: Vector2, delta: float):
	#await get_tree().create_timer(.5).timeout
	var rotation_speed := TURN_SPEED
	var v: Vector2 = turn_point - global_position
	var angle := v.angle()
	var r := global_rotation
	var angle_delta: float = rotation_speed * delta
	angle = lerp_angle(r, angle, 1.0)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	global_rotation = angle

func HearNoise(noisemaker: Object) -> void:
	if state != PURSUE or CHECK_LAST:
		var noise_loc = noisemaker.global_position
		noise_heard = noise_loc
		heard_noise = true
		#state = CHECK_SOUND
		#AlertMob(noise_heard)

func AlertMob(alert_position: Vector2) -> void: ### CURRENTLY NOT BEING USED ###
	for i in mob:
		### Find random point around this position
		#var random_pos := RandomPosition(alert_position)
		#i.MobAlert(random_pos)
		i.MobAlert(alert_position)
	#alerted_mob = true

func MobAlert(alert_position: Vector2) -> void: ### CURRENTLY NOT BEING USED ###
	if state != PURSUE or CHECK_LAST or CHECK_SOUND:
		state = MOB_MENTALITY
		mob_position = alert_position

func Hit(damage: int) -> void:
	OneShotSFX.set_stream(BULLET_HIT_ACTOR)
	OneShotSFX.play()
	#print(hitpoints)
	#Play SFX
	#Bleed
	hitpoints -= damage
	#print(hitpoints)
	Bleed()
	if hitpoints <= 0:
		Die()

func Bleed() -> void:
	var blood := EFFECT.instantiate()
	get_parent().add_child(blood)
	print("Blood Parent: " + str(get_parent()))
	blood.RandomSprite(blood.zombie_blood)
	blood.set_z_index(3)
	blood.position = self.global_position

func Die() -> void:
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	#$HurtBox/CollisionShape2D.disabled = true
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	#dead = true
	var corpse := EFFECT.instantiate()
	var death_cry := EFFECT_AUDIO.instantiate()
	get_parent().add_child(corpse)
	get_parent().add_child(death_cry)
	death_cry.PlayRandom(death_cry.zombie_die)
	corpse.SetSprite(corpse.ZOMBIE_CORPSE)
	death_cry.position = self.global_position
	corpse.position = self.global_position
	self.queue_free()

func DrawRay() -> void:
	for i in players_in_range:
		#print(i)
		var index := players_in_range.find(i)
		rays[index].target_position = to_local(i.position)
		if rays[index].get_collider() == i:
			player_in_sight = true
			if !players_in_sight.has(i):
				players_in_sight.push_back(i)
				#current_target = i
				#last_target = i
		else:
			#current_target = null
			if players_in_sight.has(i):
				players_in_sight.erase(i)
				if players_in_sight.is_empty():
					current_target = null
					player_in_sight = false

func CreateRay() -> void:
	var raycast := RayCast2D.new()
	self.add_child(raycast)
	raycast.owner = self
	rays.push_back(raycast)

func CheckDistance() -> void:
	if !players_in_sight.is_empty():
		for i in players_in_sight:
			if current_target == null:
				current_target = i
				last_target = i
			else:
				var distance_i := self.position.distance_to(i.position)
				var distance_ct := self.position.distance_to(current_target.position)
				if distance_i < distance_ct:
					current_target = i
					last_target = i

func _on_vision_cone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body_node = body
		player_in_range = true
		players_in_range.push_back(body)
		CreateRay()
		#if players_in_sight.is_empty():
			#state = CAST

func _on_vision_cone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		var body_index := players_in_range.find(body)
		var ray: Object = rays[body_index]
		ray.queue_free()
		rays.erase(ray)
		players_in_range.erase(body)
		players_in_sight.erase(body)
		if players_in_sight.is_empty():
			player_in_sight = false
		if body == current_target:
			#current_target_last_position = (current_target.global_position - self.position).normalized()
			current_target = null
		if players_in_range.is_empty():
			player_in_range = false
			#print("Should have worked")
			#state = IDLE


func _on_last_target_timer_timeout() -> void:
	#await get_tree().physics_frame
	#last_timer_inactive = true
	#last_target = null
	last_timer_finished = true
	#print("LastTargetTimer Timeout")

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func _on_attack_range_body_entered(body: Node2D) -> void:
	#var player = body.get_parent()
	if body.is_in_group("player"):
		#speed = 110
		attack_range.push_back(body)

func _on_attack_range_body_exited(body: Node2D) -> void:
	#var player = body.get_parent()
	if body.is_in_group("player"):
		#speed = generated_speed
		attack_range.erase(body)

func _on_mob_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombies"):
		mob.push_back(body)

func _on_mob_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("zombies"):
		mob.erase(body)

func _on_point_move_timer_timeout() -> void:
	point_timer_finished = true

func _on_bite_hit_box_area_entered(area: Area2D) -> void:
	#print("Area Entered Bite Range")
	#print(area)
	var victim = area.get_parent()
	if victim.is_in_group("player"):
		if can_bite:
			Bite(victim)

func _on_bite_timer_timeout() -> void:
	can_bite = true
	$BiteHitBox/CollisionPolygon2D.set_deferred("disabled", false)
