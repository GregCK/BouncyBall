extends RigidBody2D

var first_touch
var release

onready var visuals = $Visuals
onready var label = $Visuals/Label
onready var crackSprite = $Visuals/CrackSprite

var goal = null
var vec_to_goal = null

export var flings = 4
export var max_bounces = 3
var curr_bounces = 0
var won = false

signal die

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()
	crackSprite.set_frame(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !won:
		process_fling(delta)
	else:
		pass
#		vec_to_goal = -(self.get_global_position() - goal.get_global_position())
#		var impulse = vec_to_goal * delta
#		linear_velocity = vec_to_goal * delta * 300
#		add_force(Vector2(),impulse)
#		rotate(delta)

func process_fling(delta):
	if (Input.is_action_just_pressed("Click")):
		first_touch = get_global_mouse_position()
	if (Input.is_action_just_released("Click") and first_touch != null):
		release = get_global_mouse_position()
		
		var dir = (release - first_touch).normalized()
		linear_velocity = dir * delta * 30000
		
		flings -= 1
		if flings <= 0:
			die()
		update_label()


func win(new_goal):
	goal = new_goal
	
	gravity_scale = 1
	
	won = true


var rotationSpeed = 0

func rotate(delta):
	var new_roation_degrees = visuals.rotation_degrees + (rotationSpeed * delta)
	visuals.rotation_degrees += fmod(new_roation_degrees, 360)
	if rotationSpeed < 2:
		rotationSpeed += 1

func update_label():
	var flings_string = str(flings)
	label.set_text(flings_string)


func _on_Ball3_body_entered(_body):
	curr_bounces += 1
	if curr_bounces > max_bounces:
		die()
	var percent_completed = float(curr_bounces) / float(max_bounces)
	var frame = int(percent_completed * 12)
	crackSprite.set_frame(frame)

func die():
	emit_signal("die")
	queue_free()
