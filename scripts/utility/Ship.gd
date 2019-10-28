extends Area2D

export var tp_path = ""

onready var gc = get_node("/root/Game_Controller")

func body_enter( body ):
	if gc.pc.i_node == body:
		if gc.pc.current_energy >= gc.pc.max_energy:
			gc.pc.current_energy = 0
			gc.sc.sfx("ship")
			#remove this line for real game
			gc.sc.bgm("song2")
			gc.move_stage(tp_path, 0)
		else:
			gc.sd("You don't have enough power to lift off yet!")
