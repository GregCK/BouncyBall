extends RigidBody2D


const sprite0 = preload("res://Assets/deathParticle.png")
const sprite1 = preload("res://Assets/deathParticle1.png")

onready var sprite = $Sprite

var max_bounces = 3
var curr_bounces = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var sprite_num = rng.randi_range(0,1)
	match sprite_num:
		0:
			sprite.texture = sprite0
		1:
			sprite.texture = sprite1


func init(initial_velocity:Vector2):
	linear_velocity = initial_velocity

func _on_DeathParticle_body_entered(body):
	if curr_bounces > max_bounces:
		queue_free()
	else:
		curr_bounces += 1
