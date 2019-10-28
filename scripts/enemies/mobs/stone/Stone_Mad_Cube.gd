extends "res://scripts/enemies/mob_templates/Mad_Cube.gd"

func _ready():
	self.speed = 100.0
	self.max_hp = 30.0
	self.damage = 30.0
	hp_init(20)