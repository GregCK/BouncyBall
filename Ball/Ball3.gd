extends RigidBody2D

var first_touch
var release

onready var label = $Label
onready var crackSprite = $CrackSprite


export var flings = 4
export var max_bounces = 12
var curr_bounces = 0

signal die

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()
	crackSprite.set_frame(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_fling(delta)

func process_fling(delta):
	if (Input.is_action_just_pressed("Click")):
		first_touch = get_global_mouse_position()
	if (Input.is_action_just_released("Click")):
		release = get_global_mouse_position()
		
		var dir = (release - first_touch).normalized()
		linear_velocity = dir * delta * 30000
		
		flings -= 1
		if flings <= 0:
			die()
		update_label()


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
