extends "res://scripts/enemies/mob_templates/Mad_Cube.gd"

func _ready():
	self.speed = 150.0
	self.max_hp = 25.0
	self.damage = 20.0
	hp_init(20)