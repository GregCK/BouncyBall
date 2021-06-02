extends RigidBody2D


var first_touch
var release

enum{
	START,
	AIR,
	WALL
}

#number of actions ball has left until level is lost
#actions include air and wall jumps
export var action = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true) 
	set_gravity(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("Click")):
		first_touch = get_global_mouse_position()
	if (Input.is_action_just_released("Click")):
		release = get_global_mouse_position()
		
		var dir = -(release - first_touch)#.normalized()
		
		linear_velocity = dir * delta * 300
		set_gravity(true)


func set_gravity(isGravity):
	if isGravity:
		set_gravity_scale(4)
	else:
		set_gravity_scale(0) 

func _physics_process(delta):
	pass

func reset_to_top():
	if global_position.y > 300:
		var newPosition = Vector2(global_position.x, 0)
		set_global_position(newPosition)
	
