extends "res://scripts/enemies/templates/Enemy_Template.gd"

#Mob template extends to melee and ranged mobs
export var damage = 0.0

func _ready():
	self.add_to_group("Mobs")
