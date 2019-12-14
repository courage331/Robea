extends Control

#let's just say id is exists
#next work, id is network name.

var id  #connect with Login scene.

func _ready():
	Bgm.count +=1
	if(Bgm.count==1):
		_bgm_start()
		
func _bgm_start():
	Bgm._ready()


func _on_Button_pressed():
	Global.goto_scene("res://SceneFolder/OptionScene.tscn")


func _on_Button2_pressed():
	#Global.goto_scene("res://World.tscn")
	get_tree().get_root().get_node("Scene1").hide()
	#현수 id logic -> name
	Network.create_server(id)
	#Network.connect_to_server(id)
	Bgm.count =0


func _on_Button3_pressed():
	Global.goto_scene("res://SceneFolder/ShopScene.tscn")
