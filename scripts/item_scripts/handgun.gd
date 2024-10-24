extends Area2D

var interactable := false

func _ready() -> void:
	await get_tree().create_timer(.05).timeout
	interactable = true




func _on_body_entered(body: Node2D) -> void:
	if body.inventory[1] == "none" and interactable:
		body.inventory[1] = "handgun"
		if body.inventory_slot == 1:
			body.can_fire = true ### May pose a problem
			body.current_wield = "handgun"
			body.Handgun.visible = true
		self.queue_free()
	else:
		pass
