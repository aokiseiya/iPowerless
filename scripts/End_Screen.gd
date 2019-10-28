extends Node

onready var gc = get_node("/root/Game_Controller")

func _on_Play_Button_pressed():
	get_tree().quit()
