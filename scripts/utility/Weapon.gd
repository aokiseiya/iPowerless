extends Area2D

export var weapon_name = ""

onready var gc = get_node("/root/Game_Controller")

func body_enter( body ):
	if gc.pc.i_node == body:
		gc.pc.set_weapon(weapon_name)
		gc.mark_done(self)
		gc.sc.sfx("battery")
		#remove next line in real game
		gc.sd("You have got a weapon module! You now have more attack speed and damage!")
		self.queue_free()
