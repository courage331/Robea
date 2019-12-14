extends Area2D

const COLLAPSE_SCENE = preload("res://Collapse/CollapsingFloor.tscn")
const TYPE = "ROOM"
var center = Vector2()
var incircle = false
var outcircle = false
var collapsing = false
var triggered = false
var timeout = 10

func _ready():
	center = get_global_position()

func _process(delta):
	if !triggered:
		check_collapse()

func check_collapse():
	if !incircle && outcircle:
		triggered = true
		collapse_start()
		
	
func collapse_start():
	var a = COLLAPSE_SCENE.instance()
	get_parent().add_child(a)
	a.start_at(Vector2(240,135))
	#get_parent().get_parent().get_node(get_parent().get_path()).queue_free()


