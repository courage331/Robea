extends CanvasLayer

var num =0
var pos = 0
var equip=0


func start_at(x,y):
	pos = Vector2(x,y)
	
	

	
func _ready():
	$Start_image.modulate = Color(1, 1, 1, 0.5)	
	$Start_image2.modulate=Color(1,1,1,0.6)
	
	
func _change_image(num):
	if(num == 1):
		get_node("tack_image").show()
		get_node("gum_image").hide()
		equip=1
		print("num=1")
	
	elif(num==2):
		get_node("gum_image").show()
		get_node("tack_image").hide()
		equip=2
		print("num=2")

func _on_Button_pressed():
	if(equip==1):
		get_parent().using = true
		get_parent().item_loop(1)
		print("1111")
	
	elif(equip==2):
		get_parent().using = true
		get_parent().item_loop(2)
		print("2222")
		
	elif(equip==0):
		print("000000")
	
	
