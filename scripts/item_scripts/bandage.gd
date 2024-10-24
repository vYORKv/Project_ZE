extends Area2D

var interactable := false

func _ready() -> void:
	await get_tree().create_timer(.05).timeout
	interactable = true


func _on_body_entered(body: Node2D) -> void:
	if interactable:
		body.inventory[3] = "bandage"
		body.bandages += 1
		if body.inventory_slot == 3:
			body.current_wield = "bandage"
			body.Bandage.visible = true
		self.queue_free()
	else:
		pass
