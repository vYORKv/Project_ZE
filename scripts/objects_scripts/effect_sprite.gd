extends Sprite2D

const BLOOD_SPLATTER := preload("res://assets/graphics/effects/blood_splatter.png")
const BLOOD_SPLATTER_Z := preload("res://assets/graphics/effects/blood_splatter_z.png")
const ZOMBIE_CORPSE := preload("res://assets/graphics/actors/zombies/zombie_corpse.png")
const YELLOW_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/yellow_corpse.png")

func SetSprite(sprite: Texture2D) -> void:
	self.set_texture(sprite)
