extends Control
const default_time = 3
var time = 0

func _ready():
	Bgm._music_stop()

func init():
	get_node("CheckNetwork")._ready()
	get_node("Error").text = "Connecting..."

func _process(delta):
	time += delta
	$TextureProgress.updateTime()

func _on_HTTPCheckNetwork_connection_success(): #단말이 NW 연결 됐으면 > 로그인 씬으로
	#GPGS.gpgs.signInInteractive()
	Global.goto_scene("res://Init/LoginScene.tscn")
	pass

func _on_HTTPCheckNetwork_error_connection_failed(code, message): #단말이 NW 연결 됐으면 > 에러 
	get_node("Error").text = "Uh-oh! Are you connected to Network?"
	print('@init: ' + message)

func _on_play_game_services_sign_in_success(signInType, playerID):
	get_node("Error").text = "SUCCESS"
	get_node("Error").visible = true
	Global.goto_scene("res://SceneFolder/MainScene.tscn")

func _on_play_game_services_player_info_failure(signInType):
	get_node("Error").text = "_on_play_game_services_player_info_failure"
	get_node("Error").visible = true
	
func _on_play_game_services_sign_in_failure(signInType):
	get_node("Error").text = "_on_play_game_services_sign_in_failure"
	get_node("Error").visible = true
	
