extends Sprite2D

const BLOOD_SPLATTER_1 := preload("res://assets/graphics/effects/blood_splatter_1.png")
const BLOOD_SPLATTER_2 := preload("res://assets/graphics/effects/blood_splatter_2.png")
const BLOOD_SPLATTER_3 := preload("res://assets/graphics/effects/blood_splatter_3.png")
const BLOOD_SPLATTER_4 := preload("res://assets/graphics/effects/blood_splatter_4.png")
const BLOOD_SPLATTER_5 := preload("res://assets/graphics/effects/blood_splatter_5.png")
const BLOOD_SPLATTER_Z_1 := preload("res://assets/graphics/effects/blood_splatter_z_1.png")
const BLOOD_SPLATTER_Z_2 := preload("res://assets/graphics/effects/blood_splatter_z_2.png")
const BLOOD_SPLATTER_Z_3 := preload("res://assets/graphics/effects/blood_splatter_z_3.png")
const BLOOD_SPLATTER_Z_4 := preload("res://assets/graphics/effects/blood_splatter_z_4.png")
const BLOOD_SPLATTER_Z_5 := preload("res://assets/graphics/effects/blood_splatter_z_5.png")
const ZOMBIE_CORPSE := preload("res://assets/graphics/actors/zombies/zombie_corpse.png")
const YELLOW_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/yellow_corpse.png")
const BLUE_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/blue_corpse.png")
const BROWN_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/brown_corpse.png")
const ORANGE_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/orange_corpse.png")
const PINK_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/pink_corpse.png")
const PURPLE_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/purple_corpse.png")
const RED_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/red_corpse.png")
const WHITE_CORPSE := preload("res://assets/graphics/actors/player/player_corpses/white_corpse.png")

var human_blood := [BLOOD_SPLATTER_1, BLOOD_SPLATTER_2, BLOOD_SPLATTER_3, BLOOD_SPLATTER_4, BLOOD_SPLATTER_5]
var zombie_blood := [BLOOD_SPLATTER_Z_1, BLOOD_SPLATTER_Z_2, BLOOD_SPLATTER_Z_3, BLOOD_SPLATTER_Z_4, BLOOD_SPLATTER_Z_5]

func SetSprite(sprite: Texture2D) -> void:
	self.set_texture(sprite)

func RandomSprite(sprite_array: Array) -> void:
	#var array_length = sprite_array.size()
	#var random_sprite = randi() % array_length
	#var final_sprite = sprite_array[random_sprite]
	var random_sprite = sprite_array.pick_random()
	self.set_texture(random_sprite)

func CorpseSprite(color: String) -> void:
	if color == "yellow":
		self.set_texture(YELLOW_CORPSE)
	elif color == "blue" or "blue1" or "blue2":
		self.set_texture(BLUE_CORPSE)
	elif color == "brown":
		self.set_texture(BROWN_CORPSE)
	elif color == "orange":
		self.set_texture(ORANGE_CORPSE)
	elif color == "pink":
		self.set_texture(PINK_CORPSE)
	elif color == "purple":
		self.set_texture(PURPLE_CORPSE)
	elif color == "red" or "red1" or "red2":
		self.set_texture(RED_CORPSE)
	elif color == "white":
		self.set_texture(WHITE_CORPSE)
