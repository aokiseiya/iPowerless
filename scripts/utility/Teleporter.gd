extends Area2D

export var tp_path = ""
export var tp_side = 0

onready var gc = get_node("/root/Game_Controller")

func body_enter( body ):
	if gc.pc.i_node == body:
		gc.move_stage(tp_path, tp_side)
