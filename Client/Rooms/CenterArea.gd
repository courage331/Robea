extends Area2D
"""
var howfar = 0
var center = Vector2()
var check_first = 50
var set_trigger = false
var a = 10

func _ready():
	$CheckTimer.start()
	$CollapseTimer.start()
	center = get_global_position()
	

	

func _on_CheckTimer_timeout():
	if !set_trigger:
		for area in get_parent().get_node("CheckArea").get_overlapping_areas():
			if area.get("TYPE") == "ROOM" && check_first > 0:
				if howfar <= center.distance_to(area.center):
					howfar = center.distance_to(area.center)
				check_first -= 1
			elif check_first == 0 && !set_trigger:
				set_trigger = true
				get_parent().get_node("CheckArea").queue_free()
				print(howfar)
				set_circle()
			
func set_circle():
	var circle = CircleShape2D.new()
	var collision = CollisionShape2D.new()
	circle.set_radius(howfar - 128)
	collision.set_shape(circle)
	add_child(collision)
	#$Incircle.shape.set_radius(howfar - 128)
	#get_parent().get_node("CenterArea2/Outcircle").shape.set_radius(howfar + 128)
	#get_parent().get_node("CenterArea2").check_out()
	#print($Incircle.shape.get_radius())
	#print(get_parent().get_node("CenterArea2/Outcircle").shape.get_radius())
	for area in get_overlapping_areas():
			if area.get("TYPE") == "ROOM":
				area.incircle = true
	#check_incircle()

func check_incircle():
	if a > 0:
		for area in get_overlapping_areas():
			if area.get("TYPE") == "ROOM":
				area.incircle = false
		a -= 1
	else:
		a = 10


func _on_CollapseTimer_timeout():
	for area in get_overlapping_areas():
		if area.get("TYPE") == "ROOM":
			pass
			#if area.center.distance_to(center) > howfar
"""
