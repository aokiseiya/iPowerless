extends "res://scripts/enemies/templates/Melee_Mob.gd"

func _integrate_forces(s):
	chase_player(s, self.speed)
	face_move_direction(s)
