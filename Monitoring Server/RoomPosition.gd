extends Position2D

onready var testroom = preload("res://TestRoom.tscn")
onready var testroom2 = preload("res://TestRoom2.tscn")
onready var testroom3 = preload("res://TestRoom3.tscn")
onready var room1 = preload("res://Rooms/Room1.tscn")
onready var room2 = preload("res://Rooms/Room2.tscn")
onready var room3 = preload("res://Rooms/Room3.tscn")
onready var room4 = preload("res://Rooms/Room4.tscn")

onready var roomCollapse = preload("res://Rooms/RoomCollapse.tscn")

onready var itemroom = preload("res://Rooms/ItemRoom/ItemRoom.tscn")
onready var wallTop = preload("res://Wall_Top.tscn")
onready var wallLeft = preload("res://Wall_Left.tscn")
onready var wallRight = preload("res://Wall_Right.tscn")
onready var wallBottom = preload("res://Wall_Bottom.tscn")

var room_count = 0
var room_collapse = 0

var map_array = [ [0, 0, 0, 0, 0 ,0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0 , 0],
				[0, 0, 0, 0, 0 ,0, 0, 0 ],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]]

slave var Smap_array = map_array


func init():
	randomize()
	#rand_seed(123)
	var x = 1
	var y = 1
	for i in range(512):
		map_array[x][y] = randi() % 7 + 1
		var dir = (randi() % 4) * 90
		x += lengthdir_x(1, dir)
		y += lengthdir_y(1, dir)
		x = clamp(x, 0, 7)
		y = clamp(y, 0, 7)
		if map_array[x][y] == 0:
			room_count += 1
			if room_count == 24:
				break

remote func build_server_map():
	if get_tree().is_network_server():
		if map_array[1][1] != 8:
			init()
			map_array[1][1] = 8
			var x = 0
			var y = 0
			for a in range(512):
				x = randi() % 7
				y = randi() % 7
				if map_array[x][y] != 0 && map_array[x][y] != 8:
					map_array[x][y] = 666
					break
			print(map_array[0])
			print(map_array[1])
			print(map_array[2])
			print(map_array[3])
			print(map_array[4])
			print(map_array[5])
			print(map_array[6])
			print(map_array[7])
			rpc('build_map', map_array)
			
			for y in range(8):
				var row = map_array[y]
				for x in range(8):
						if row[x] == 1:
							var room = room1.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 2:
							var room = room2.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 3:
							var room = room3.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 4:
							var room = room1.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 5:
							var room = room2.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 6:
							var room = room3.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 7:
							var room = room4.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 8:
							var room = itemroom.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							room.map_x = y
							room.map_y = x
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
						elif row[x] == 666:
							var room = roomCollapse.instance()
							var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
							room.set_position(room_pos)
							get_node("/root/World").call_deferred("add_child",room)
							create_walls(x, y, room)
			#get_parent()._ready()
			get_parent().get_node("FullMap").map_array = map_array
			get_parent().map_array = map_array
			#get_parent()._player_map()
		else:
			rpc('build_map', map_array)
	
	
remote func build_map(mapArray):
	map_array = mapArray
	for y in range(8):
		var row = map_array[y]
		for x in range(8):
				if row[x] == 1:
					var room = room1.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 2:
					var room = room2.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 3:
					var room = room3.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 4:
					var room = room1.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 5:
					var room = room2.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 6:
					var room = room3.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 7:
					var room = room4.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 8:
					var room = itemroom.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					room.map_x = y
					room.map_y = x
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
				elif row[x] == 666:
					var room = roomCollapse.instance()
					var room_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
					room.set_position(room_pos)
					get_node("/root/World").call_deferred("add_child",room)
					create_walls(x, y, room)
	get_parent().map_array = map_array
	get_parent()._player_map()
	
	
func lengthdir_x(length, direction):
	return round(length * cos(direction))
	

func lengthdir_y(length, direction):
	return round(length * sin(direction))
	
func create_walls(x, y, room):
	if y-1 == -1 || map_array[y-1][x] == 0:
		var twall = wallTop.instance()
		var wall_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
		twall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",twall)
	if x-1 == -1 || map_array[y][x-1] == 0:
		var lwall = wallLeft.instance()
		var wall_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
		lwall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",lwall)
	if x+1 == 8 || map_array[y][x+1] == 0:
		var rwall = wallRight.instance()
		var wall_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
		rwall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",rwall)
	if y+1 == 8 || map_array[y+1][x] == 0:
		var bwall = wallBottom.instance()
		var wall_pos = Vector2(480 * x, 270 * y) + Vector2(-480, -270)
		bwall.set_position(wall_pos)
		get_node("/root/World").call_deferred("add_child",bwall)