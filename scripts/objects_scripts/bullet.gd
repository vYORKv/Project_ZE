extends CharacterBody2D

var EffectAnimationScene := preload("res://scenes/objects_scenes/effect_animation.tscn")

const SPEED := 800
var damage := 1
var type := "none"
var wait_time := .5

#func _ready():
	#$Timer.set_wait_time(.6)
	#$Timer.timeout.connect(TimerTimeout)
	#$Timer.start()

func _ready() -> void:
	BulletCheck()
	#$Timer.set_wait_time(wait_time)
	#$Timer.timeout.connect(TimerTimeout)
	#$Timer.start()
	

#func _physics_process(delta):
	#var collision = move_and_collide(velocity.normalized() * delta * SPEED)

func _physics_process(delta: float) -> void:
	var collision: Object = move_and_collide(velocity.normalized() * delta * SPEED)

func TimerTimeout() -> void:
	self.queue_free()

func BulletCheck() -> void:
	if type == "handgun":
		damage = 35
		#wait_time = .5
		$Timer.set_wait_time(1)
		$Timer.timeout.connect(TimerTimeout)
		$Timer.start()
	elif type == "rifle":
		damage = 50
		#wait_time = 1.0
		$Timer.set_wait_time(2)
		$Timer.timeout.connect(TimerTimeout)
		$Timer.start()
	elif type == "shotgun":
		damage = 35
		$Timer.set_wait_time(.4)
		$Timer.timeout.connect(TimerTimeout)
		$Timer.start()

#func _on_hit_box_area_entered(area):
	#var victim = area.get_parent()
	#if victim.is_in_group("Actor"):
		#victim.Hit()
	#self.queue_free()
#
#func _on_hit_box_body_entered(body):
	#
	#self.queue_free()

func EnvironmentHit() -> void:
	var env_hit: Object = EffectAnimationScene.instantiate()
	get_parent().add_child(env_hit)
	env_hit.EnvironmentHit()
	env_hit.position = self.global_position

func _on_hitbox_area_entered(area: Area2D) -> void:
	#$Hitbox/CollisionShape2D.disabled = true
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	#print("bullet area entered")
	velocity = Vector2.ZERO
	var victim: Object = area.get_parent()
	if victim.is_in_group("actors"):
		victim.Hit(damage)
		victim.bleeding = true
		victim.Bleed()
	self.queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	#print("bullet body entered")
	if body.is_in_group("environment"):
		velocity = Vector2.ZERO
		EnvironmentHit()
		self.queue_free()
