extends RigidBody2D

onready var gc = get_node("/root/Game_Controller")
#Enemy_Template extends to Mob_Template and Boss_Template

var custom_death = false
var hurt_sound = "enemy_hurt"
var death_sound = "small_enemy_death"

export var max_hp = 0.0
export var speed = 0.0

var current_hp = 0.0

#Crowd controlled
var cced = false
onready var cc_timer = get_node("CC_Timer")

var bullet_class = preload("res://scripts/Bullet.gd")

onready var hp_ui = get_node("Enemy_HP_UI")

onready var player = get_parent().get_node("i")

func _ready():
	self.add_to_group("Enemies")
#	var enemies_group = get_tree().get_nodes_in_group("Enemies")
#	for i in enemies_group:
#		self.add_collision_exception_with(i)
#	pass

func hp_init(width):
	current_hp = max_hp
	hp_ui.init(max_hp, width)

#Function run when collision is detected
func hit( b ):
	#Checks if collision occured with a bullet
	if(b extends bullet_class):
		#Modify hp and remove bullet from scene.
		current_hp -= b.damage
		b.destroy()
		if current_hp > 0:
			gc.sc.sfx(hurt_sound)
			hp_ui.set_hp( current_hp )
		else:
			death()

func death():
	gc.mark_done(self)
	if !custom_death:
		gc.sc.sfx(death_sound)
		self.queue_free()

#Physics process functions
#Args for these is physics2dbodystate
func chase_player(s, chase_speed):
	if !self.cced:
		var target_direction = player.get_global_pos() - self.get_global_pos()
		target_direction = target_direction.normalized()
		s.set_linear_velocity(target_direction * chase_speed)

func face_move_direction(s):
	if s.get_linear_velocity().x > 0:
		get_node("Rotate").set_scale( Vector2 (1, 1))
	elif s.get_linear_velocity().x < 0:
		get_node("Rotate").set_scale( Vector2 (-1, 1))

#CC
func feared(time):
	cced = true
	var target_direction = self.get_global_pos() - player.get_global_pos()
	target_direction = target_direction.normalized()
	self.set_linear_velocity(target_direction * 100)
	cc_timer.set_wait_time(time)
	cc_timer.start()

func cc_timeout():
	cced = false

