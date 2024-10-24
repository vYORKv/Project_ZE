extends Area2D

var interactable := false

func _ready() -> void:
	await get_tree().create_timer(.05).timeout
	interactable = true


func _on_body_entered(body: Node2D) -> void:
	if interactable:
		print("Water: " + str(body.water))
		body.water += 1
		print("Water: " + str(body.water))
		self.queue_free()
	else:
		pass
