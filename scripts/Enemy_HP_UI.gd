extends Node2D

var max_hp
var hp_percent = 0.0
var width

onready var hp_bar = get_node("HP")
onready var no_hp_bar = get_node("No_HP")

var show = false

func init(max_hp, width):
	self.hide()
	self.max_hp = max_hp
	self.width = width
	no_hp_bar.set_scale( Vector2(width, 4) )

func set_hp(hp):
	self.show()
	hp_percent = hp / max_hp
	hp_bar.set_scale( Vector2(width * hp_percent, 4) )
	hp_bar.set_pos( Vector2( (width * 0.5 * (hp_percent - 1)), 0) )

	