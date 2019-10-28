extends Node

onready var gc = get_node("/root/Game_Controller")

func _ready():
	gc.set_stage()
	gc.pc.refresh_hp_ui()
	gc.pc.refresh_energy_ui()

func show_desc(text):
	get_node("UI_Foreground/Desc/Label").set_text(text)
	get_node("UI_Foreground/Desc").show()
	get_node("UI_Foreground/Aim").hide()
	get_node("UI_Foreground/Desc/Timer").start()

func _on_Timer_timeout():
	get_node("UI_Foreground/Desc").hide()
	get_node("UI_Foreground/Aim").show()
