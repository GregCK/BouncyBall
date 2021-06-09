extends Line2D


var target
var point
export(NodePath) var targetPath
var trailLength = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_points()
	target = get_node(targetPath)


func _process(delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	point = target.global_position
	while get_point_count() > trailLength:
		remove_point(0)
	add_point(point)
