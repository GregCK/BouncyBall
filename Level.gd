extends Node2D


onready var ball = $Ball

var isBallAlive = true


# Called when the node enters the scene tree for the first time.
func _ready():
	ball.connect("die", self, "handle_die")


func _process(_delta):
	if isBallAlive == false:
		if Input.is_action_just_pressed("Click"):
			get_tree().reload_current_scene()

func handle_die():
	isBallAlive = false
