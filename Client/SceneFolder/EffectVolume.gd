extends TextureProgress




func _ready():
	max_value = 24
	min_value = -80
	
	
func volume_up():
	
	value +=8
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), value)
	Bgm._effectsound_start()
	
func volume_down():
	
	value -=8
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), value)
	Bgm._effectsound_start()
	
