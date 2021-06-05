extends RigidBody2D


onready var rightRayCasts = $RightWallRayCasts
onready var leftRayCasts = $LeftWallRayCasts

onready var label = $Label


enum{
	START,
	AIR,
	WALL
}


var state = START


var is_on_left = false
var is_on_right = false

const jump_velocity_left = Vector2(500, -250)
const jump_velocity_right = Vector2(-500, -250)

var first_touch
var release

const air_gravity = 4
const wall_gravity = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	set_gravity_scale(0)


func _process(delta):
	
	match state:
		START:
			start_state(delta)
			label.text = "START"
		AIR:
			air_state(delta)
			label.text = "AIR"
		WALL:
			wall_state()
			label.text = "WALL"


func wall_state():
	if Input.is_action_just_pressed("Click"):
		if is_on_left:
			set_linear_velocity(jump_velocity_left)
		elif is_on_right:
			set_linear_velocity(jump_velocity_right)
		state = AIR
	
	if is_on_left:
		if !wall_curr_detected(true):
			state = AIR
	elif is_on_right:
		if !wall_curr_detected(false):
			state = AIR


func air_state(delta):
	var on_left_wall = wall_just_detected(true)
	var on_right_wall = wall_just_detected(false)
	if  on_left_wall or on_right_wall:
		
		if wall_curr_detected(true):
			pass
		else:
			pass
		
		
		var old_velocity = get_linear_velocity()
		var new_velocity = Vector2(0, old_velocity.y)
		set_linear_velocity(new_velocity)
		
		
		if wall_curr_detected(true):
			pass
		else:
			pass
		
		
		set_gravity_scale(wall_gravity)
		
		
		state = WALL


func move_until_back_on_wall():
	pass


func start_state(delta):
	if (Input.is_action_just_pressed("Click")):
		first_touch = get_global_mouse_position()
	if (Input.is_action_just_released("Click")):
		release = get_global_mouse_position()
		
		var dir = -(release - first_touch)#.normalized()
		
		linear_velocity = dir * delta * 300
		set_gravity_scale(air_gravity)
		
		state = AIR



#returns true iff ball is currently on wall
func wall_curr_detected(isLeft:bool):
	var raycasts = null
	if isLeft:
		raycasts = leftRayCasts
	else:
		raycasts = rightRayCasts
		
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			update_on_wall_variables(isLeft, true)
			return true
	update_on_wall_variables(isLeft, false)
	return false


#should only return true when ball has initially hit wall
func wall_just_detected(isLeft:bool):
	var raycasts = null
	if isLeft:
		raycasts = leftRayCasts
	else:
		raycasts = rightRayCasts
	for raycast in raycasts.get_children():
		if raycast.is_colliding() == false:
			update_on_wall_variables(isLeft, false)
		elif is_on_left == false:
			update_on_wall_variables(isLeft, true)
			return true
	
	return false


func update_on_wall_variables(isLeft:bool, isOn: bool):
	if isLeft:
		is_on_left = isOn
	else:
		is_on_right = isOn
