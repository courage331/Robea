extends CanvasLayer

var map_array = [ [0, 0, 0, 0, 0 ,0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0 , 0],
				[0, 0, 0, 0, 0 ,0, 0, 0 ],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]]

var show = false

func ViewMap():
	if !show:
		show = true
		get_node("MinimapButton/Map").show()
		if map_array[0][0] != 0:
			get_node("MinimapButton/Map/Sprite_00").show()
		if map_array[1][0] != 0:
			get_node("MinimapButton/Map/Sprite_01").show()
		if map_array[2][0] != 0:
			get_node("MinimapButton/Map/Sprite_02").show()
		if map_array[3][0] != 0:
			get_node("MinimapButton/Map/Sprite_03").show()
		if map_array[4][0] != 0:
			get_node("MinimapButton/Map/Sprite_04").show()
		if map_array[5][0] != 0:
			get_node("MinimapButton/Map/Sprite_05").show()
		if map_array[6][0] != 0:
			get_node("MinimapButton/Map/Sprite_06").show()
		if map_array[7][0] != 0:
			get_node("MinimapButton/Map/Sprite_07").show()
		if map_array[0][1] != 0:
			get_node("MinimapButton/Map/Sprite_10").show()
		if map_array[1][1] != 0:
			get_node("MinimapButton/Map/Sprite_11").show()
		if map_array[2][1] != 0:
			get_node("MinimapButton/Map/Sprite_12").show()
		if map_array[3][1] != 0:
			get_node("MinimapButton/Map/Sprite_13").show()
		if map_array[4][1] != 0:
			get_node("MinimapButton/Map/Sprite_14").show()
		if map_array[5][1] != 0:
			get_node("MinimapButton/Map/Sprite_15").show()
		if map_array[6][1] != 0:
			get_node("MinimapButton/Map/Sprite_16").show()
		if map_array[7][1] != 0:
			get_node("MinimapButton/Map/Sprite_17").show()
		if map_array[0][2] != 0:
			get_node("MinimapButton/Map/Sprite_20").show()
		if map_array[1][2] != 0:
			get_node("MinimapButton/Map/Sprite_21").show()
		if map_array[2][2] != 0:
			get_node("MinimapButton/Map/Sprite_22").show()
		if map_array[3][2] != 0:
			get_node("MinimapButton/Map/Sprite_23").show()
		if map_array[4][2] != 0:
			get_node("MinimapButton/Map/Sprite_24").show()
		if map_array[5][2] != 0:
			get_node("MinimapButton/Map/Sprite_25").show()
		if map_array[6][2] != 0:
			get_node("MinimapButton/Map/Sprite_26").show()
		if map_array[7][2] != 0:
			get_node("MinimapButton/Map/Sprite_27").show()
		if map_array[0][3] != 0:
			get_node("MinimapButton/Map/Sprite_30").show()
		if map_array[1][3] != 0:
			get_node("MinimapButton/Map/Sprite_31").show()
		if map_array[2][3] != 0:
			get_node("MinimapButton/Map/Sprite_32").show()
		if map_array[3][3] != 0:
			get_node("MinimapButton/Map/Sprite_33").show()
		if map_array[4][3] != 0:
			get_node("MinimapButton/Map/Sprite_34").show()
		if map_array[5][3] != 0:
			get_node("MinimapButton/Map/Sprite_35").show()
		if map_array[6][3] != 0:
			get_node("MinimapButton/Map/Sprite_36").show()
		if map_array[7][3] != 0:
			get_node("MinimapButton/Map/Sprite_37").show()
		if map_array[0][4] != 0:
			get_node("MinimapButton/Map/Sprite_40").show()
		if map_array[1][4] != 0:
			get_node("MinimapButton/Map/Sprite_41").show()
		if map_array[2][4] != 0:
			get_node("MinimapButton/Map/Sprite_42").show()
		if map_array[3][4] != 0:
			get_node("MinimapButton/Map/Sprite_43").show()
		if map_array[4][4] != 0:
			get_node("MinimapButton/Map/Sprite_44").show()
		if map_array[5][4] != 0:
			get_node("MinimapButton/Map/Sprite_45").show()
		if map_array[6][4] != 0:
			get_node("MinimapButton/Map/Sprite_46").show()
		if map_array[7][4] != 0:
			get_node("MinimapButton/Map/Sprite_47").show()
		if map_array[0][5] != 0:
			get_node("MinimapButton/Map/Sprite_50").show()
		if map_array[1][5] != 0:
			get_node("MinimapButton/Map/Sprite_51").show()
		if map_array[2][5] != 0:
			get_node("MinimapButton/Map/Sprite_52").show()
		if map_array[3][5] != 0:
			get_node("MinimapButton/Map/Sprite_53").show()
		if map_array[4][5] != 0:
			get_node("MinimapButton/Map/Sprite_54").show()
		if map_array[5][5] != 0:
			get_node("MinimapButton/Map/Sprite_55").show()
		if map_array[6][5] != 0:
			get_node("MinimapButton/Map/Sprite_56").show()
		if map_array[7][5] != 0:
			get_node("MinimapButton/Map/Sprite_57").show()
		if map_array[0][6] != 0:
			get_node("MinimapButton/Map/Sprite_60").show()
		if map_array[1][6] != 0:
			get_node("MinimapButton/Map/Sprite_61").show()
		if map_array[2][6] != 0:
			get_node("MinimapButton/Map/Sprite_62").show()
		if map_array[3][6] != 0:
			get_node("MinimapButton/Map/Sprite_63").show()
		if map_array[4][6] != 0:
			get_node("MinimapButton/Map/Sprite_64").show()
		if map_array[5][6] != 0:
			get_node("MinimapButton/Map/Sprite_65").show()
		if map_array[6][6] != 0:
			get_node("MinimapButton/Map/Sprite_66").show()
		if map_array[7][6] != 0:
			get_node("MinimapButton/Map/Sprite_67").show()
		if map_array[0][7] != 0:
			get_node("MinimapButton/Map/Sprite_70").show()
		if map_array[1][7] != 0:
			get_node("MinimapButton/Map/Sprite_71").show()
		if map_array[2][7] != 0:
			get_node("MinimapButton/Map/Sprite_72").show()
		if map_array[3][7] != 0:
			get_node("MinimapButton/Map/Sprite_73").show()
		if map_array[4][7] != 0:
			get_node("MinimapButton/Map/Sprite_74").show()
		if map_array[5][7] != 0:
			get_node("MinimapButton/Map/Sprite_75").show()
		if map_array[6][7] != 0:
			get_node("MinimapButton/Map/Sprite_76").show()
		if map_array[7][7] != 0:
			get_node("MinimapButton/Map/Sprite_77").show()
	else:
		show = false
		get_node("MinimapButton/Map").hide()

func _on_MinimapButton_pressed():
	ViewMap()
