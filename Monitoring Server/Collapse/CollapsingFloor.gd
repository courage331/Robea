extends Area2D

const HOLE_SCENE = preload("res://Collapse/CollapseHole.tscn")
const TYPE = "FLOORHOLE"

func start_at(pos):
	set_position(pos)
	$CollapseTimer.start()

func _on_CollapseTimer_timeout():
	var b = HOLE_SCENE.instance()
	get_parent().add_child(b)
	b.start_at(get_position())
