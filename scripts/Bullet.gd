extends RigidBody2D

var damage = 0

var direction
var speed = 0

func set_properties(damage, speed, time, direction):
	self.damage = damage
	self.speed = speed
	self.get_node("Timer").set_wait_time(time)
	self.direction = direction
	
	self.set_linear_velocity(self.direction * self.speed)
	self.set_rot(atan2(direction.x, direction.y))
	
func destroy():
	self.queue_free()
