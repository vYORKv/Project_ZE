extends AudioStreamPlayer2D

const DEATH_CRY_Z := preload("res://assets/audio/hit_sfx/death_cry_z.wav")
const DIE_1_Z := preload("res://assets/audio/zombie_sfx/die_1.wav")
const DIE_2_Z := preload("res://assets/audio/zombie_sfx/die_2.wav")
const DIE_3_Z := preload("res://assets/audio/zombie_sfx/die_3.wav")
const DIE_MALE := preload("res://assets/audio/player_sfx/die_male.wav")
const DIE_FEMALE := preload("res://assets/audio/player_sfx/die_female.wav")

#@onready var SFX := $SFX
var zombie_die := [DEATH_CRY_Z]#[DIE_1_Z, DIE_2_Z, DIE_3_Z]

func Play(sound: AudioStream) -> void:
	self.set_stream(sound)
	self.play()
	await self.finished
	self.queue_free()

func PlayRandom(sfx_array: Array) -> void:
	#var array_length = sfx_array.size()
	#var random_sfx = randi() % array_length
	#var final_sfx = sfx_array[random_sfx]
	var random_sfx = sfx_array.pick_random()
	self.set_stream(random_sfx)
	self.play()
	await self.finished
	self.queue_free()
