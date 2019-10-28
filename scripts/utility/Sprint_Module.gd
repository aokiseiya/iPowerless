extends Area2D

export var weapon_name = ""

onready var gc = get_node("/root/Game_Controller")

func body_enter( body ):
	if gc.pc.i_node == body:
		gc.pc.shift_ability = "sprint"
		gc.get_game().get_node("UI_Foreground/Ability_1/None").hide()
		gc.get_game().get_node("UI_Foreground/Ability_1/Sprint").show()
		gc.mark_done(self)
		gc.sc.sfx("battery")
		gc.sd("You can now sprint! Press SHIFT to sprint!")
		self.queue_free()
