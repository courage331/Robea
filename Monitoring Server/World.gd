extends Node
#const Player = preload('res://Player.tscn')
#var new_player = Player.instance()
var master_player

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
	
func _player_map():
	#new_player.map_array = map_array
	#new_player.make_minimap()
	#$Player.map_array = map_array
	#$Player.make_minimap()
	pass
	
func collapse_me(parentnode,path):
	parentnode.get_node(path).queue_free()