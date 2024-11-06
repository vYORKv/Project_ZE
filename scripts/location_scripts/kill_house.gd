extends Node2D

var countdown := 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		$Player.input_allowed = true
		# All players can move


func _on_start_timer_timeout() -> void:
	StartFX()
