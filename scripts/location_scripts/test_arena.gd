extends Node2D

const BULLET := preload("res://scenes/objects_scenes/bullet.tscn")

@onready var BulletTimer := $BulletTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BulletTimer.start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/meta_scenes/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bullet_timer_timeout() -> void:
	var bullet := BULLET.instantiate()
	bullet.type = "handgun"
	get_parent().add_child(bullet)
	bullet.position = $BulletSpawn.global_position
	bullet.look_at($BulletAim.global_position)
	bullet.velocity = $BulletAim.global_position - bullet.position
	BulletTimer.start()
