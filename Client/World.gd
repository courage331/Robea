extends Node
const Player = preload('res://Player.tscn')
var master_player
var new_player = Player.instance()
var count = 0


var map_array = [ [0, 0, 0, 0, 0 ,0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0 , 0],
				[0, 0, 0, 0, 0 ,0, 0, 0 ],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]]
				
func _ready():
	Bgm._music_stop()
	$GameBgm.play()
	$CanvasLayer/InventoryButton/Inventory_Sprite.modulate=Color(1,1,1,0.6)
	if not(get_tree().is_network_server()): #if clinet -> set my player / else(server) -> not need to swpanning player
		#my player
		print("im no tserver not(get_tree().is_network_server() is:", not(get_tree().is_network_server()))
		#get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
		#get_tree().connect('server_disconnected', self, '_on_server_disconnected')
		get_tree().get_root().get_node("/root/World").add_child(new_player)
		new_player.name = str(get_tree().get_network_unique_id())
		new_player.set_network_master(get_tree().get_network_unique_id())
		master_player = new_player
		_player_inventory()
		_player_itembutton()
		start_text()
		var left =5
		update_score(left)
		
		
		var info = Network.self_data
		print(Network.self_data)
		new_player.init(info.position)#info.name, info.position, false)s
		print(info.position)
		print("my player")
	else:
		print("pass")
		#if player is server -> not spawn player
	
func _next_player():
	Bgm._music_stop()
	$GameBgm.play()
	if not(get_tree().is_network_server()): #if clinet -> set my player / else(server) -> not need to swpanning player
		#my player
		print("im no tserver not(get_tree().is_network_server() is:", not(get_tree().is_network_server()))
		#get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
		#get_tree().connect('server_disconnected', self, '_on_server_disconnected')
		get_tree().get_root().get_node("/root/World").add_child(new_player)
		new_player.name = str(get_tree().get_network_unique_id())
		new_player.set_network_master(get_tree().get_network_unique_id())
		master_player = new_player
		_player_inventory()
		_player_itembutton()
		start_text()
		var left =5
		update_score(5)
		
		
		var info = Network.self_data
		print(Network.self_data)
		new_player.init(info.position)#info.name, info.position, false)s
		print(info.position)
		print("my player")
	else:
		print("pass")
		#if player is server -> not spawn player

func _player_map():
	#print(map_array)
	new_player.map_array = map_array
	new_player.make_minimap()
	#$Player.map_array = map_array
	#$Player.make_minimap()
	
func collapse_me(parentnode,path):
	parentnode.get_node(path).queue_free()
	

func _player_inventory():
	new_player._make_inventory()
	
	
func _player_itembutton():
	print("make")
	new_player._make_itembutton()

func start_text():
	$LeftPlayer/PlayerText.text = "Left : "

func update_score(left):
	$LeftPlayer/PlayerNum.text = str(left)
	

func _on_InventoryButton_pressed():
	if(count %2 == 0):
		new_player._show_inventory()
		count +=1
		
	
	else:
		new_player._hide_inventory()
		count +=1