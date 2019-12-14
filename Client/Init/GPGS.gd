extends Node
var gpgs

func _init():
	if(Engine.has_singleton("GodotPlayGameServices")):
			gpgs = Engine.get_singleton("GodotPlayGameServices")
			gpgs.init(get_instance_id(), true)
			gpgs.keepScreenOn(true)
			gpgs.clearCache()
			#gpgs.signInInteractive()
			#Global.goto_scene("res://SceneFolder/MainScene.tscn")