extends Node2D

onready var wallTop = preload("res://Wall_Top.tscn")
onready var wallLeft = preload("res://Wall_Left.tscn")
onready var wallRight = preload("res://Wall_Right.tscn")
onready var wallBottom = preload("res://Wall_Bottom.tscn")
const Monster = preload("res://Monster/base/EnemyType1/EnemyType1.tscn")

var monA
var monB
var monC

var map_x = 0
var map_y = 0

var EnemyCount = 0

func _ready():
	pass
	#spawn_enemy()
	
func spawn_enemy():
	monA = Monster.instance()
	add_child(monA)
	monA.start_at(Vector2(360,135))

func update_map():
	create_walls(map_x,map_y)
	#monA.dying = true
	
func create_walls(y, x):
	if y-1 != -1 && get_parent().get_node("RoomPosition").map_array[y-1][x] != 0:
		var bwall = wallBottom.instance()
		var wall_pos = Vector2(480 * x, 270 * (y-1)) + Vector2(-480, -270)
		bwall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",bwall)
	if x-1 != -1 && get_parent().get_node("RoomPosition").map_array[y][x-1] != 0:
		var rwall = wallRight.instance()
		var wall_pos = Vector2(480 * (x-1), 270 * y) + Vector2(-480, -270)
		rwall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",rwall)
	if x+1 != 8 && get_parent().get_node("RoomPosition").map_array[y][x+1] != 0:
		var lwall = wallLeft.instance()
		var wall_pos = Vector2(480 * (x+1), 270 * y) + Vector2(-480, -270)
		lwall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",lwall)
	if y+1 != 8 && get_parent().get_node("RoomPosition").map_array[y+1][x] != 0:
		var twall = wallTop.instance()
		var wall_pos = Vector2(480 * x, 270 * (y+1)) + Vector2(-480, -270)
		twall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",twall)

func destroy():
	update_map()
	queue_free()