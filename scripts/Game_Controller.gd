
#Game controller that handles player information, room and map structures etc.
extends Node

onready var pc = load("res://scripts/Player_Controller.tscn").instance()
onready var sc = load("res://scripts/Sound_Controller.tscn").instance()

#Dict to keep record of items already taken/ enemies already killed
var done_dict = {"hi////////":"node"}
var current_stage_path

var next_stage
var spawn_side = 0

func _ready():
	self.add_child(sc)
	sc.set_owner(self)
	#Some unneeded test code below
#	pc.init_game()
#	pc.printmaxhp()
#	pc.queue_free()
#	pc = load("res://scripts/Player_Controller.tscn").instance()
#	pc.printmaxhp()

func to_end_screen():
	get_tree().change_scene("res://scenes/End_Screen.tscn")

func sd(text):
	get_game().show_desc(text)

func game_start():
	#Add player controller node to self and set as owner
	self.add_child(pc)
	pc.set_owner(self)
	#Init player data
	pc.init_game()
	get_tree().change_scene("res://scenes/Game.tscn")
	
	#SET FIRST STAGE
	next_stage = "res://stages/white/White_1.tscn"
#	next_stage = "res://stages/stone/Stone_3.tscn"

func move_stage(path, side):
	next_stage = path
	spawn_side = side
	get_tree().reload_current_scene()

func set_stage():
	var stage = load(self.next_stage).instance()
	get_game().add_child(stage)
	stage.set_owner(get_game())
	next_stage = ""

#To manage done_dict
func set_current_stage_path(path):
	self.current_stage_path = path

func mark_done(node):
	if !done_dict.has(current_stage_path):
		done_dict[current_stage_path] = []
#	print(get_node(current_stage_path).get_path_to(node))
	done_dict[current_stage_path].append(get_node(current_stage_path).get_path_to(node))

func get_game():
	return get_node("/root/Game")