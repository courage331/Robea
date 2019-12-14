extends Area2D

const TYPE = "HOLE"
signal destroy

func start_at(pos):
	set_position(pos)
	$Timer.start()


func _on_Timer_timeout():
	get_parent().destroy()
	

