extends CanvasLayer

var area1 = null
var chosenPlayer = false


func set_circle():
	chosenPlayer = null
	for body in $Area2D.get_overlapping_bodies():
		if body.get("TYPE") == "PLAYER":
			body.get_node("GridSnapper/Camera2D").current = false
	check_next()

func check_next():
	while !chosenPlayer:
		for body in $Area2D.get_overlapping_bodies():
			if body.get("TYPE") == "PLAYER":
				randomize()
				if randi() % 2 == 0:
					chosenPlayer = true
					body.get_node("GridSnapper/Camera2D").current = true

func _on_CameraButton_pressed():
	set_circle()
