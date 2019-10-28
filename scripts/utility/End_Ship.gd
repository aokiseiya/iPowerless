extends Area2D

export var tp_path = ""

onready var gc = get_node("/root/Game_Controller")

func body_enter( body ):
	if gc.pc.i_node == body:
		if gc.pc.current_energy >= gc.pc.max_energy:
			gc.sc.sfx("ship")
			gc.to_end_screen()
		else:
			gc.sd("You don't have enough power to lift off yet!")