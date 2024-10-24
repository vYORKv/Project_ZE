extends AnimatedSprite2D

const BULLET_HIT_ENV := preload("res://assets/audio/hit_sfx/bullet_hit_env.wav")

@onready var SFX := $SFX

func Play(animation_string: StringName) -> void:
	self.play(animation_string)
	await self.animation_finished
	self.queue_free()

func EnvironmentHit() -> void:
	SFX.set_stream(BULLET_HIT_ENV)
	SFX.play()
	self.play("environment_hit")
	await SFX.finished
	await self.animation_finished
	self.queue_free()
