extends Area2D

export var energy_amount = 0

onready var gc = get_node("/root/Game_Controller")

func body_enter( body ):
	if gc.pc.i_node == body:
		gc.pc.obtain_energy(energy_amount)
		gc.mark_done(self)
		gc.sc.sfx("battery")
		self.queue_free()
