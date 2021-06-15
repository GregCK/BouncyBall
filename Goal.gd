extends Node2D


onready var timer = $Timer
onready var sound = $AudioStreamPlayer
onready var collisionShape = $Area2D/CollisionShape2D

signal levelDone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Ball":
		collisionShape.scale.x = 20
		collisionShape.scale.y = 20
		sound.play()
		body.win(self)
		timer.start()


func _on_Timer_timeout():
	
	emit_signal("levelDone")
