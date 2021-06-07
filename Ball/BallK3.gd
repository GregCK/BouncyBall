extends KinematicBody2D

var velocity = Vector2(-200, 200)

signal die

func _physics_process(delta):
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var new_dir
		if velocity.x > 0:
			new_dir = collision_info.normal.rotated(deg2rad(90))
			velocity = new_dir * 300
		else:
			new_dir = collision_info.normal.rotated(deg2rad(-90))
			velocity = new_dir * 300
