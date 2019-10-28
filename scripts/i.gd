extends RigidBody2D

onready var gc = get_node("/root/Game_Controller")
onready var pc = get_node("/root/Game_Controller/Player_Controller")

var BASE_PLAYER_SPEED = 250
var PLAYER_SPRINT_SPEED = BASE_PLAYER_SPEED * 2.0
var BULLET_SPEED = 500

var player_speed = BASE_PLAYER_SPEED

#Inputs
var move_right = false
var move_left = false
var move_up = false
var move_down = false
var q_ability = false
var shift_ability = false

#Weapon stats
var wp_atk_damage = 0.0
var wp_atk_speed = 0.0
var wp_bullet_speed = 0.0
var wp_bullet_time = 0.0

func set_wp(atk_damage, atk_speed, bullet_speed, bullet_time):
	self.wp_atk_damage = atk_damage
	self.wp_atk_speed = atk_speed
	self.wp_bullet_speed = bullet_speed
	self.wp_bullet_time = bullet_time

var shoot = false
var shoot_cd = 0.0

#Used to manage change in state when using an ability
var can_move = true
var using_ability = false
var post_damage_immunity = false
onready var post_damage_immunity_timer = get_node("Timers/Post_Damage_Immunity")
onready var anim_player = get_node("AnimationPlayer")

var bullet = preload("res://objects/bullets/Bullet.tscn")
#var enemy_class = preload("res://scripts/Enemy.gd")

onready var anim_sprite = get_node("Rotate/AnimatedSprite")
onready var current_anim = anim_sprite.get_animation()

#A node2D is used as a container to hold nodes that needs to rotate in runtime, as rigid bodies manage their own transformations, unless inside _integrate_forces function
onready var rotate = get_node("Rotate")

func _ready():
	pc.set_i_node(self.get_path())
	pc.apply_weapon()

func move_to_spawn():
	if gc.spawn_side > 0:
		var target_spawn_pos = get_node(gc.current_stage_path).get_node("Spawn_" + str(gc.spawn_side))
		self.set_pos(target_spawn_pos.get_pos())

func _integrate_forces(s):
	var delta = s.get_step()
	var new_anim = current_anim
	check_input()
	
	var move_direction = Vector2(0,0)
	
	#Find movement direction and normalize
	if move_right && !move_left:
		move_direction = Vector2(1, move_direction.y)
	if move_left && !move_right:
		move_direction = Vector2(-1, move_direction.y)
	if move_up && !move_down:
		move_direction = Vector2(move_direction.x , -1)
	if move_down && !move_up:
		move_direction = Vector2(move_direction.x , 1)
	
	if can_move:
		move_direction = move_direction.normalized()
		s.set_linear_velocity(move_direction * player_speed)
	
	#Change animation
	if s.get_linear_velocity() != Vector2( 0, 0 ):
		new_anim = "walking"
	else:
		new_anim = "idle"
	
	if new_anim != current_anim:
		current_anim = new_anim
		anim_sprite.set_animation(new_anim)
	
	#Check if node is facing towards mouse
	if get_global_mouse_pos() > self.get_global_pos():
		self.set_scale( Vector2( 1, 1) )
	elif get_global_mouse_pos() < self.get_global_pos():
		self.set_scale( Vector2( -1, 1 ) )
	
	if shoot && shoot_cd == 0:
		var shoot_direction = get_global_mouse_pos() - self.get_global_pos()
		shoot_direction = shoot_direction.normalized()
		var bi = bullet.instance()
		bi.set_pos(get_node("Rotate/Shoot_Pos").get_global_pos())
		bi.set_properties(wp_atk_damage, wp_bullet_speed, wp_bullet_time, shoot_direction)
		get_node("Bullet_Container").add_child(bi)
		shoot_cd = 1 / wp_atk_speed
		gc.sc.sfx("shoot2")
	else:
		if shoot_cd > 0:
			shoot_cd -= delta
			if shoot_cd < 0:
				shoot_cd = 0
	
	#Abilities trigger
#	if q_ability:
#		charge()
	if shift_ability && pc.shift_ability == "sprint":
		player_speed = PLAYER_SPRINT_SPEED
	else:
		player_speed = BASE_PLAYER_SPEED
	
	#Take damage if no immunity
	if !check_immune():
		manage_damage()

#-----------

func check_input():
	move_right = Input.is_action_pressed("ui_right")
	move_left = Input.is_action_pressed("ui_left")
	move_up = Input.is_action_pressed("ui_up")
	move_down = Input.is_action_pressed("ui_down")
	shoot = Input.is_action_pressed("shoot")
	q_ability = Input.is_action_pressed("q_ability")
	shift_ability = Input.is_action_pressed("shift_ability")

func check_immune():
	var flag = false
	if post_damage_immunity:
		flag = true
	return flag

#Managing enemies on player and thus damage
#ds == damage source
var ds_order_dict = {}
var ds_damage_dict = {}
var ds_key_count = 0

func _on_HitBox_body_enter_shape( body_id, body, body_shape, area_shape ):
	if body:
		if body.is_in_group("Enemies"):
			ds_order_dict[body_id] = ds_key_count
			ds_key_count += 1
			ds_damage_dict[body_id] = body.damage

func _on_HitBox_body_exit_shape( body_id, body, body_shape, area_shape ):
	if body:
		if body.is_in_group("Enemies"):
			ds_order_dict.erase(body_id)
			ds_damage_dict.erase(body_id)

#Make sure the first damage source to enter
func manage_damage():
	var smallest_key = -1
	if !ds_order_dict.empty():
		for key in ds_order_dict:
			if smallest_key == -1:
				smallest_key = key
			else:
				if ds_order_dict[key] < ds_order_dict[smallest_key]:
					smallest_key = key
		pc.damage(ds_damage_dict[smallest_key])
		post_damage_immunity = true
		anim_player.play("blinking")
		post_damage_immunity_timer.start()

func _on_Post_Damage_Immunity_timeout():
	post_damage_immunity = false
	anim_player.stop()
	self.get_node("Rotate/AnimatedSprite").show()

#Abilities
func charge():
	var charge_direction = get_global_mouse_pos() - self.get_global_pos()
	charge_direction = charge_direction.normalized()
	self.apply_impulse(Vector2(0,0), charge_direction * 1000)


	