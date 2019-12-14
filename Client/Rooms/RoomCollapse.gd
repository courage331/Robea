extends Node2D

var howfar = 0
var center = Vector2()
var first_check_count = 30
var second_check_count = 30
var third_check_count = 30
var set_trigger = false

var area1 = null
var area2 = null

func _ready():
	center = get_global_position()
	#check_first()
	#$Timer.start()

	
	
	
func check_first():
	if first_check_count > 0:
		for area in get_node("CheckArea").get_overlapping_areas():
			if area.get("TYPE") == "ROOM":
				area.incircle = false
				first_check_count -= 1
				if howfar <= center.distance_to(area.center):
					howfar = center.distance_to(area.center)
	else:
		if !set_trigger:
			set_trigger = true
			#get_node("CheckArea").queue_free()
	set_circle()


func set_circle():
	var circle = CircleShape2D.new()
	var collision = CollisionShape2D.new()
	var check_area = Area2D.new()
	circle.set_radius(howfar - 128)
	add_child(check_area)
	get_node(check_area.get_path()).add_child(collision)
	collision.set_shape(circle)
	area1 = check_area
	
	var circle2 = CircleShape2D.new()
	var collision2 = CollisionShape2D.new()
	var check_area2 = Area2D.new()
	circle2.set_radius(howfar + 128)
	add_child(check_area2)
	get_node(check_area2.get_path()).add_child(collision2)
	collision2.set_shape(circle2)
	area2 = check_area2
	test()



func test():
	if area1 != null:
		if second_check_count > 0:
			for area in area1.get_overlapping_areas():
				if area.get("TYPE") == "ROOM":
					second_check_count -= 1
					area.incircle = true
		area1.queue_free()
		area1 = null
			
			
	if area2 != null:
		if third_check_count > 0:
			for area in area2.get_overlapping_areas():
				if area.get("TYPE") == "ROOM":
					third_check_count -= 1
					area.outcircle = true
		area2.queue_free()
		area2 = null
		howfar -= 128

			

func _on_Timer_timeout():
	first_check_count = 30
	second_check_count = 30
	third_check_count = 30
	check_first()
