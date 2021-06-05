extends KinematicBody2D


var velocity = Vector2.ZERO
const air_gravity = 500
const wall_gravity = 50

var first_touch
var release

enum{
	START,
	AIR
}

var state = START

#number of actions ball has left until level is lost
#actions include air and wall jumps
export var actions_left = 5



func _physics_process(delta):
	match state:
		START:
			start_state(delta)
		AIR:
			air_state(delta)

	
	
	apply_gravity(delta)
	
	#velocity = move_and_slide(velocity, Vector2.UP)




func air_state(delta):
	move_and_slide(velocity, Vector2.UP)
	if !is_on_wall():
		bounce()
	else:
		if Input.is_action_just_pressed("Click"):
			bounce()

func wall_jump():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if abs(collision.normal.x) > 0.95:
			velocity = velocity.bounce(collision.normal)

func bounce():
	if get_slide_count() > 0:
		var collision = get_slide_collision(0) #KinematicCollision2D, normal -1, 0.005
	
	#	var collision = move_and_collide(velocity * delta) #KinematicCollision2D, normal -1, 0.004
	
		if collision:
			velocity = velocity.bounce(collision.normal)

func start_state(delta):
	var fling = check_initial_fling(delta)
	if fling != null:
		velocity += fling

func check_initial_fling(delta):
	if (Input.is_action_just_pressed("Click")):
		first_touch = get_global_mouse_position()
	if (Input.is_action_just_released("Click")):
		release = get_global_mouse_position()
		
		state = AIR
		
		var dir = -(release - first_touch)#.normalized()
		return dir * delta * 300
	
	return null

func apply_gravity(delta):
	if !is_on_wall():
		velocity.y += air_gravity * delta
	else:
#		velocity.y += wall_gravity * delta
		velocity.y = 0
