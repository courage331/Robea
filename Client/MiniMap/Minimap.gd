extends Node2D

var pos = 0


"""func _ready():
	pos = get_global_position()
	set_global_position(pos)"""
	

func start_at(x,y):
	pos = Vector2(x,y)
	
	
func _physics_process(delta):
	set_global_position(pos)