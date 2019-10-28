#Allows the player object to easily communicate with the UI
extends Node
#Player variables

onready var gc = get_node("/root/Game_Controller")

var i_node
#onready var game = get_node("/root/Game")
var max_hp = 0.0
var current_hp = 0.0

var max_energy = 0.0
var current_energy = 0.0
var weapon = ""

var shift_ability = ""
var q_ability = ""

func set_i_node(path):
	self.i_node = get_node(path)

func init_game():
	max_hp = 200.0
	current_hp = max_hp
	current_energy = 0.0
	max_energy = 1000.0
	weapon = ""
	shift_ability = ""
	q_ability = ""

func damage(amount):
	gc.sc.sfx("hurt")
	current_hp -= amount
	if current_hp < 0:
		current_hp = 0
	refresh_hp_ui()
	if current_hp == 0:
		game_over()

func obtain_energy(amount):
	current_energy += amount
	refresh_energy_ui()

func refresh_hp_ui():
	gc.get_game().get_node("UI_Foreground/HP_Bar/Label").set_text(str(current_hp) + "/" + str(max_hp))

func refresh_energy_ui():
	gc.get_game().get_node("UI_Foreground/Energy_Bar/Label").set_text(str(current_energy) + "/" + str(max_energy))

func set_weapon(weapon):
	self.weapon = weapon
	apply_weapon()

func apply_weapon():
	var group = gc.get_game().get_node("UI_Foreground/Weapon")
	#i_node.set_wp args are (atk_damage, atk_speed, bullet_speed, bullet_time)
	hide_all_weapons()
	if !self.weapon: #noweapon
		i_node.set_wp(6.0, 2.0, 500.0, 1.0)
		group.get_node("None").show()
	elif self.weapon == str("iCore-1"):
		i_node.set_wp(7.0, 3.5, 500.0, 1.0)
		group.get_node("iCore-1").show()

func hide_all_weapons():
	var group = gc.get_game().get_node("UI_Foreground/Weapon")
	for N in group.get_children():
		N.hide()

func game_over():
	gc.sc.sfx("player_death")
	get_tree().change_scene("res://scenes/Game_Over.tscn")