extends KinematicBody2D

onready var leftRayCast = $LeftRayCast2D
onready var rightRayCast = $RightRayCast2D


var first_touch
var release

var velocity = Vector2.ZERO
const gravity = 100

enum{
	START,
	AIR,
	WALL
}

var state = START


func _physics_process(delta):
	if state != START:
		apply_gravity(delta)
	
	var fling = check_initial_fling(delta)
	if fling != null:
		velocity += fling
	
	
	if check_is_valid_wall(leftRayCast) or check_is_valid_wall(rightRayCast):
		state = WALL
	else:
		state = AIR
	
	move_and_slide(velocity, Vector2.UP)


func start_state(delta):
	var fling = check_initial_fling(delta)
	if fling != null:
		velocity += fling


func apply_gravity(delta):
	velocity.y += gravity * delta


func check_is_valid_wall(wall_raycast):
	if wall_raycast.is_colliding():
		return true
	else:
		return false

func check_initial_fling(delta):
	if (Input.is_action_just_pressed("Click")):
		first_touch = get_global_mouse_position()
	if (Input.is_action_just_released("Click")):
		release = get_global_mouse_position()
		
		state = AIR
		
		var dir = -(release - first_touch)#.normalized()
		return dir * delta * 300
	
	return null
