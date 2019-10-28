extends Node2D

onready var gc = get_node("/root/Game_Controller")

func _ready():
	self.get_node("Collision").hide()
	gc.set_current_stage_path(self.get_path())
	if gc.done_dict.has(self.get_path()):
		var dd = gc.done_dict[self.get_path()]
		for i in dd:
			self.get_node(i).queue_free()
	get_node("i").move_to_spawn()