extends CanvasLayer

var num =0
var pos = 0

func start_at(x,y):
	pos = Vector2(x,y)
	$inventory_kan.modulate = Color(1, 1, 1, 0.5)
	get_node("inventory_kan/item1_tack").modulate = Color(1, 1, 1, 1)
	get_node("inventory_kan/item2_gum").modulate = Color(1, 1, 1, 1)
	get_node("inventory_kan/item3_glue").modulate = Color(1, 1, 1, 1)
	get_node("inventory_kan/item4_eraser").modulate = Color(1, 1, 1, 1)
	
	"""
func _physics_process(delta):
	set_global_position(pos)"""
	
func add_item(num):
	if (num==2):
		get_node("inventory_kan/item2_gum").show()
		
	
	elif(num==1):
		get_node("inventory_kan/item1_tack").show()
		
		
	elif(num==3):
		get_node("inventory_kan/item3_glue").show()
		
		
	elif(num==4):
		get_node("inventory_kan/item4_eraser").show()
		
		
	
		
func minus_item(num):
	if (num==2):
		get_node("inventory_kan/item2_gum").hide()
		
	
	elif(num==1):
		get_node("inventory_kan/item1_tack").hide()
		
	
	
func change_item():
	pass