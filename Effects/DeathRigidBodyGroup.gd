extends Node2D


const deathRigidBody = preload("res://Effects/DeathRigidBody.tscn")

const num_bodies = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in num_bodies:
		add_death_rigidBody()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func add_death_rigidBody():
	var d = deathRigidBody.instance()
	var x_vel = rand_range(-200, 200)
	var y_vel = rand_range(-200, 200)
	var init_vel = Vector2(x_vel, y_vel)
	d.init(init_vel)
	
	var world = get_tree().current_scene
	world.call_deferred("add_child", d)
	d.global_position = global_position
