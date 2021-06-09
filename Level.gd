extends Node2D


onready var ball = $Ball
onready var goal = $Goal

var isBallAlive = true

export var nextLevel = "res://World.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	ball.connect("die", self, "handle_die")
	goal.connect("levelDone", self, "go_to_next_level")


func _process(_delta):
	if isBallAlive == false:
		if Input.is_action_just_pressed("Click"):
			get_tree().reload_current_scene()

func handle_die():
	isBallAlive = false

func go_to_next_level():
	SceneChanger.change_scene(nextLevel)
