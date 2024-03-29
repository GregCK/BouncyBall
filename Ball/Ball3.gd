extends RigidBody2D

var first_touch
var release

const deathEffect = preload("res://Effects/DeathEffect.tscn")
const deathRigidBody = preload("res://Effects/DeathRigidBody.tscn")
const deathRigidBodyGroup = preload("res://Effects/DeathRigidBodyGroup.tscn")

onready var visuals = $Visuals
onready var label = $Visuals/Label
onready var crackSprite = $Visuals/CrackSprite
onready var trail = $Trail
onready var bounce_sound = $BounceSound
onready var fling_sound = $FlingSound

var goal = null
var vec_to_goal = null

export var flings = 4
export var max_bounces = 3
var curr_bounces = 0
var won = false

signal die

# Called when the node enters the scene tree for the first time.
func _ready():
	trail.visible = false
	update_label()
	crackSprite.set_frame(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !won and flings > 0:
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

#		fling_sound.play()
		update_label()
		trail.visible = true


func win(new_goal):
	goal = new_goal
	
	gravity_scale = 3
	
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


var bounce_pitch = 1.0

func make_bounce_sound():
	bounce_sound.play()
	bounce_pitch += 0.1
	bounce_sound.set_pitch_scale(bounce_pitch)

func _on_Ball3_body_entered(_body):
	Globals.camera.shake(100, 0.1, 200)
	make_bounce_sound()
	curr_bounces += 1
	if curr_bounces > max_bounces:
		die()
	else:
		var percent_completed = float(curr_bounces) / float(max_bounces)
		var frame = int(percent_completed * 12)
		crackSprite.set_frame(frame)

func die():
	add_death_rigidBody_group()
	
	emit_signal("die")
	queue_free()


func add_death_particle():
	var d = deathEffect.instance()
	var world = get_tree().current_scene
	world.add_child(d)
	d.global_position = global_position

func add_death_rigidBody():
	var d = deathRigidBody.instance()
	var world = get_tree().current_scene
#	world.add_child(d)
	world.call_deferred("add_child", d)
	d.global_position = global_position

func add_death_rigidBody_group():
	var d = deathRigidBodyGroup.instance()
	var world = get_tree().current_scene
#	world.add_child(d)
	world.call_deferred("add_child", d)
	d.global_position = global_position
	
	
