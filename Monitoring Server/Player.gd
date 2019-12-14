
extends KinematicBody2D

const BULLET_SCENE = preload("res://Items/Bullets/Bullet.tscn")
const DUST_SCENE = preload("res://Player/Sprites/Dust/Dust.tscn")
#actitem scenes
const ITEM_TACK_SCENE = preload("res://Items/Active/Tack/Tack_Item.tscn")
const ITEM_GUM_SCENE = preload("res://Items/Active/Gum/Gum_Item.tscn")
const GUM_SCENE = preload("res://Items/Active/Gum/act/GumAct.tscn")
const TACK_SCENE = preload("res://Items/Active/Tack/act/TackAct.tscn")

const default_health = 100
const default_damage = 1
const TYPE = "PLAYER"

var grid_position = Vector2(0,0)
var MAX_SPEED = 180 
var ACCELERATION = 6000
var motion = Vector2(0,0)
var movedir = Vector2(0,0)
var gotHurt = Vector2(0,0)
var can_shoot = true
var can_use = true
var hitstun = 0
var knockdir = Vector2(0,0)

enum STATE {IDLE, ATTACK, RETURN, WALK}
enum ACTITEM {NULL, TACK, GUM}
enum ITEM {ERASER, GLUE}

var glue_get = 0
var eraser_get = 0

var state = STATE.IDLE # 상태 
var actitem = ACTITEM.NULL

var sprite_flip = false # 스프라이트 방향 
var dust1 = true #걸을 때 먼지
var dust2 = false #걸을 때 먼지

var attacking = false

var health = default_health
var DAMAGE = default_damage
var SPEED = MAX_SPEED

var SLOW_SPEED = MAX_SPEED*0.3
var SLOW = false
var TACK_HURT = false
var TACK_IN = false

var hitmask = 1
var hitTimer = 0

var return_frame #return frame

slave var slave_position = Vector2()
slave var Smouse_position = Vector2()
slave var Shealth = health
slave var Sstate = state
slave var Ssprite_flip = sprite_flip
slave var Sshoot_signal = false
slave var Shitmask = 1
slave var Sact_item = actitem
slave var Suse_signal = false

var using = false
var shooting = false
var mouse_position = Vector2()

var fall_rotate = 0
var fall_scale = 1
var falling = false
var shaking = false
var shakepow = 0.5

var oldmap = null
var newmap = null
const MAP_SCENE = preload("res://MiniMap/Minimap.tscn")
var map_array = [ [0, 0, 0, 0, 0 ,0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0 , 0],
				[0, 0, 0, 0, 0 ,0, 0, 0 ],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0],
				[0, 0, 0, 0, 0, 0, 0, 0]]



func make_minimap():
	if oldmap == null:
		oldmap = MAP_SCENE.instance()
		add_child(oldmap)
	oldmap.start_at(((grid_position.x*2)+1) * 240 + 144 , ((grid_position.y*2)+1) * 135 - 109)
	oldmap.get_node("Sprite_PMiddle").hide()
	oldmap.get_node("Sprite_CTop").hide()
	oldmap.get_node("Sprite_CTopLeft").hide()
	oldmap.get_node("Sprite_CLeft").hide()
	oldmap.get_node("Sprite_CBottomLeft").hide()
	oldmap.get_node("Sprite_CBottom").hide()
	oldmap.get_node("Sprite_CBottomRight").hide()
	oldmap.get_node("Sprite_CRight").hide()
	oldmap.get_node("Sprite_CTopRight").hide()
	
	oldmap.get_node("Sprite_VTop").hide()
	oldmap.get_node("Sprite_VTopLeft").hide()
	oldmap.get_node("Sprite_VLeft").hide()
	oldmap.get_node("Sprite_VBottomLeft").hide()
	oldmap.get_node("Sprite_VBottom").hide()
	oldmap.get_node("Sprite_VBottomRight").hide()
	oldmap.get_node("Sprite_VRight").hide()
	oldmap.get_node("Sprite_VTopRight").hide()
	
	oldmap.get_node("Sprite_GTop").hide()
	oldmap.get_node("Sprite_GTopLeft").hide()
	oldmap.get_node("Sprite_GLeft").hide()
	oldmap.get_node("Sprite_GBottomLeft").hide()
	oldmap.get_node("Sprite_GBottom").hide()
	oldmap.get_node("Sprite_GBottomRight").hide()
	oldmap.get_node("Sprite_GRight").hide()
	oldmap.get_node("Sprite_GTopRight").hide()
	
	oldmap.get_node("Sprite_PMiddle").show()
	var map_x = grid_position.x+1
	var map_y = grid_position.y+1

	if map_y-1 != -1 && map_array[map_y-1][map_x] != -1 && map_array[map_y-1][map_x] != 0:
		if map_array[map_y-1][map_x] == 55:
			oldmap.get_node("Sprite_VTop").show()
		elif map_array[map_y-1][map_x] == 666:
			oldmap.get_node("Sprite_GTop").show()
		else:
			oldmap.get_node("Sprite_CTop").show()
	if map_y-1 != -1 && map_x-1 != -1 &&  map_array[map_y-1][map_x-1] != -1 && map_array[map_y-1][map_x-1] != 0:
		if map_array[map_y-1][map_x-1] == 55:
			oldmap.get_node("Sprite_VTopLeft").show()
		elif map_array[map_y-1][map_x-1] == 666:
			oldmap.get_node("Sprite_GTopLeft").show()
		else:
			oldmap.get_node("Sprite_CTopLeft").show()
	if map_x-1 != -1 && map_array[map_y][map_x-1] != -1 && map_array[map_y][map_x-1] != 0:
		if map_array[map_y][map_x-1] == 55:
			oldmap.get_node("Sprite_VLeft").show()
		elif map_array[map_y][map_x-1] == 666:
			oldmap.get_node("Sprite_GLeft").show()
		else:
			oldmap.get_node("Sprite_CLeft").show()
	if map_y+1 != 8 && map_x-1 != -1 && map_array[map_y+1][map_x-1] != -1 && map_array[map_y+1][map_x-1] != 0:
		if map_array[map_y+1][map_x-1] == 55:
			oldmap.get_node("Sprite_VBottomLeft").show()
		elif map_array[map_y+1][map_x-1] == 666:
			oldmap.get_node("Sprite_GBottomLeft").show()
		else:
			oldmap.get_node("Sprite_CBottomLeft").show()
	if map_y+1 != 8 && map_array[map_y+1][map_x] != -1 && map_array[map_y+1][map_x] != 0:
		if map_array[map_y+1][map_x] == 55:
			oldmap.get_node("Sprite_VBottom").show()
		elif map_array[map_y+1][map_x] == 666:
			oldmap.get_node("Sprite_GBottom").show()
		else:
			oldmap.get_node("Sprite_CBottom").show()
	if map_y+1 != 8 &&  map_x+1 != 8 && map_array[map_y+1][map_x+1] != -1 && map_array[map_y+1][map_x+1] != 0:
		if map_array[map_y+1][map_x+1] == 55:
			oldmap.get_node("Sprite_VBottomRight").show()
		elif map_array[map_y+1][map_x+1] == 666:
			oldmap.get_node("Sprite_GBottomRight").show()
		else:
			oldmap.get_node("Sprite_CBottomRight").show()
	if map_x+1 != 8 && map_array[map_y][map_x+1] != -1 && map_array[map_y][map_x+1] != 0:
		if map_array[map_y][map_x+1] == 55:
			oldmap.get_node("Sprite_VRight").show()
		elif map_array[map_y][map_x+1] == 666:
			oldmap.get_node("Sprite_GRight").show()
		else:
			oldmap.get_node("Sprite_CRight").show()
	if map_y-1 != -1 && map_x+1 != 8 && map_array[map_y-1][map_x+1] != -1 && map_array[map_y-1][map_x+1] != 0:
		if map_array[map_y-1][map_x+1] == 55:
			oldmap.get_node("Sprite_VTopRight").show()
		elif map_array[map_y-1][map_x+1] == 666:
			oldmap.get_node("Sprite_GTopRight").show()
		else:
			oldmap.get_node("Sprite_CTopRight").show()
	
	if map_array[map_y][map_x] != 666:
		map_array[map_y][map_x] = 55

func _physics_process(delta):
	if is_network_master():
		if SLOW :
			MAX_SPEED = SLOW_SPEED
		else :
			MAX_SPEED = SPEED
		collision_loop(delta)
		damage_loop()
		check_animation_loop()
		animation_loop()
		item_loop()
		$TextureProgress.updateHealth()
		
		if falling:
			set_z_index(35)
			set_scale(Vector2(fall_scale,fall_scale))
			set_rotation_degrees(fall_rotate)
			fall_rotate += 10
			if fall_scale >= 0:
				fall_scale -= 0.01
		if shaking:
			get_parent().get_node("ScreenShake").screen_shake(0.1,shakepow,100)
			if shakepow < 10:
				shakepow += 0.01
			
		
		#rset_unreliable('slave_position', position)
		#rset_unreliable('Smouse_position', mouse_position)
		#rset_unreliable('Sstate', state)
		#rset_unreliable('Ssprite_flip', sprite_flip)
		#rset_unreliable('Shealth', health)
		#rset_unreliable('Shitmask', hitmask)
		
		var axis = get_input_axis() 
		if(axis == Vector2.ZERO):  # 이동 방향 입력안하면 마찰 적용 
			if state == STATE.WALK:
				state = STATE.IDLE
			if hitstun == 0:
				apply_friction(ACCELERATION * delta)
		else: # 이동 
			if state != STATE.ATTACK:
				state = STATE.WALK
			if hitstun == 0 && !falling:
				apply_movement(axis * ACCELERATION * delta) 
			else:
				apply_knockback(knockdir.normalized() * ACCELERATION * delta *0.15 )
		motion = move_and_slide(motion)
	
		if pow(get_node("../JoystickAim/Joystick").output[0], 2) + pow(get_node("../JoystickAim/Joystick").output[1], 2) >= 0.7:
			shooting = true
			#rset_unreliable('Sshoot_signal', shooting)
		else: 
			if state == STATE.ATTACK:
				$Sprite_Player.set_frame($Sprite_Player.frame-1)
				shooting = false
				#rset_unreliable('Sshoot_signal', shooting)
				state = STATE.RETURN
				
		if Input.is_action_pressed("key_item"):
			using = true
			#rset_unreliable('Suse_signal', using)
			
		if Input.is_action_just_released("key_item"):
			using = false
			#rset_unreliable('Suse_signal', using)
			
	else:
		shooting = Sshoot_signal
		position = slave_position
		state = Sstate
		sprite_flip = Ssprite_flip
		mouse_position = Smouse_position
		health = Shealth
		using = Suse_signal
		$TextureProgress.updateHealth()
		$Sprite_Gun.look_at(mouse_position) # 무기 방향
		shoot()
		animation_loop()
		collision_loop(delta)
		damage_loop()
		item_loop()
	
	
func shoot():
	if is_network_master():
		mouse_position = Vector2(get_node("../JoystickAim/Joystick").output[0]*10000,get_node("../JoystickAim/Joystick").output[1]*10000)
		$Sprite_Gun.look_at(mouse_position) # 무기 방향
		rset_unreliable('Smouse_position', mouse_position)
	else:
		$Sprite_Gun.look_at(mouse_position) # 무기 방향
		
	if can_shoot && shooting:
		can_shoot = false
		state = STATE.ATTACK
		if ($Sprite_Gun.get_global_rotation_degrees() >= 90 && $Sprite_Gun.get_global_rotation_degrees() < 180) || ($Sprite_Gun.get_global_rotation_degrees() >= -180 && $Sprite_Gun.get_global_rotation_degrees() < -90):
			#$Sprite_Player.set_flip_h(true)
			sprite_flip = true
		elif ($Sprite_Gun.get_global_rotation_degrees() >= 0 && $Sprite_Gun.get_global_rotation_degrees() < 90) || ($Sprite_Gun.get_global_rotation_degrees() >= -90 && $Sprite_Gun.get_global_rotation_degrees() < 0) :
			#$Sprite_Player.set_flip_h(false)
			sprite_flip = false
		$GunTimer.start() # 무기 연사(장전) 시간 
		var b = BULLET_SCENE.instance()
		get_parent().add_child(b)
		b.parent = get_instance_id() 
		b.check_master = true
		if eraser_get > 0:
			b.eraser = true
		if glue_get > 0:
			b.glue = true
		#b.start_at($Sprite_Gun.get_global_rotation(),$Sprite_Gun/FirePositon.global_position)
		if sprite_flip:
			b.start_at($Sprite_Gun.get_global_rotation(),Vector2(global_position.x-20,global_position.y-4)) # 총알 생성 
		else :
			b.start_at($Sprite_Gun.get_global_rotation(),Vector2(global_position.x+20,global_position.y-4)) # 총알 생성 
		"""var aim = get_node("../JoystickAim/Joystick").output
		var aimFloat = aim.angle()
		if aim[0] < 0:
			$Sprite_Player.set_flip_h(true)
			sprite_flip = true
			b.start_at(aimFloat,Vector2(global_position.x-20,global_position.y-4)) # 총알 생성 
		elif aim[0] > 0:
			$Sprite_Player.set_flip_h(false)
			sprite_flip = false
			b.start_at(aimFloat,Vector2(global_position.x+20,global_position.y-4)) # 총알 생성 
"""
func get_input_axis():
	var axis = Vector2.ZERO
	axis = get_node("../JoystickMoving/Joystick").output
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")) # right - left로 좌우 방향 결정
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) # down - up으로 상하 방향 결정 
	if(axis[0] < 0): 
			if pow(get_node("../JoystickAim/Joystick").output[0], 2) + pow(get_node("../JoystickAim/Joystick").output[1], 2) < 0.7:
				$Sprite_Player.set_flip_h(true)
				sprite_flip = true
	elif(axis[0] > 0):
		if pow(get_node("../JoystickAim/Joystick").output[0], 2) + pow(get_node("../JoystickAim/Joystick").output[1], 2) < 0.7:
			$Sprite_Player.set_flip_h(false)
			sprite_flip = false 
	return axis.normalized() # 벡터값을 1로 만들어줌 
	
func apply_friction(amount):
	if (motion.length() > amount): 
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
	
func apply_movement(accel):
	motion += accel
	motion = motion.clamped(MAX_SPEED)

func apply_knockback(accel):
	motion += accel

func _on_GunTimer_timeout(): #GunTimer에서 지정한 시간이 다 되면
	can_shoot = true
	shooting = false
	rset_unreliable('Sshoot_signal', shooting)
	
func takeDamage(dmg): 
	health -= dmg
	#if(health <= 0):
      #Global.goto_scene("res://SceneFolder/GameOverScene.tscn")
	hitTimer = 1
	
	
		
func damage_loop():
	if hitstun > 0:
		hitstun -= 1
		
	if hitTimer > 0:
		hitTimer -= 0.2
		hitmask -= 0.01
		$Sprite_Player.modulate = Color(hitmask, 0, 0)
	else:
		hitmask = 1
		$Sprite_Player.modulate = Color(1, 1, 1)
		
	if TACK_HURT:
		$TackTimer.start()
		takeDamage(5)
		TACK_HURT = false
	
		
func _on_TackTimer_timeout():
	if TACK_IN:
		TACK_HURT = true
	else:
		TACK_HURT = false
		$TackTimer.stop()
		

func collision_loop(delta):
	for body in $Hitbox.get_overlapping_bodies():
		if body.get("DAMAGE") != null and body.get("TYPE") == "ENEMY":
			takeDamage(body.get("DAMAGE"))
			hitstun = 10
			knockdir = Vector2(global_position.x - body.global_position.x, global_position.y - body.global_position.y)
			apply_knockback(knockdir.normalized() * ACCELERATION * delta * 0.2 )
		if body.get("DAMAGE") != null and body.get("TYPE") == "EBULLET":
			takeDamage(body.get("DAMAGE"))
			body.queue_free()
		
	
	
			
func animation_loop():
	if sprite_flip:
		$Sprite_Player.set_flip_h(true)
	else:
		$Sprite_Player.set_flip_h(false)
	match state:
		STATE.IDLE:
			$Sprite_Player.play("Idle")
			$Sprite_Player.set_speed_scale(1)
		STATE.ATTACK:
				$Sprite_Player.play("Attack")
				$Sprite_Player.set_speed_scale($GunTimer.wait_time*(pow(1/$GunTimer.wait_time,2)))
		STATE.RETURN:
				$Sprite_Player.play("Return")
				$Sprite_Player.set_speed_scale(3)
		STATE.WALK:
			$Sprite_Player.play("Walk")
			$Sprite_Player.set_speed_scale(1)
					
					
func check_animation_loop():
	if $Sprite_Player.animation == "Attack" && $Sprite_Player.frame == $Sprite_Player.frames.get_frame_count("Attack")-1:
			if pow(get_node("../JoystickAim/Joystick").output[0], 2) + pow(get_node("../JoystickAim/Joystick").output[1], 2) < 0.7:
				state = STATE.RETURN
	if $Sprite_Player.animation == "Return" && $Sprite_Player.frame == $Sprite_Player.frames.get_frame_count("Return")-1:
			if pow(get_node("../JoystickAim/Joystick").output[0], 2) + pow(get_node("../JoystickAim/Joystick").output[1], 2) < 0.7:
				state = STATE.IDLE
	if $Sprite_Player.animation == "Walk" && $Sprite_Player.frame == 2 && dust1:
			dust1 = false
			dust2 = true
			var d = DUST_SCENE.instance()
			get_parent().add_child(d)
			if sprite_flip:
				d.start_at(Vector2(global_position.x+12,global_position.y+24)) # 먼지 생성 
			else :
				d.start_at(Vector2(global_position.x-12,global_position.y+24)) # 먼지 생성 
	elif $Sprite_Player.animation == "Walk" && $Sprite_Player.frame == 6 && dust2:
			dust2 = false
			dust1 = true
			var d = DUST_SCENE.instance()
			get_parent().add_child(d)
			if sprite_flip:
				d.start_at(Vector2(global_position.x+12,global_position.y+24)) # 먼지 생성 
			else :
				d.start_at(Vector2(global_position.x-12,global_position.y+24)) # 먼지 생성
				
func item_loop():
	if Input.is_action_pressed("key_item"):
		if actitem != ACTITEM.NULL && can_use:
			can_use = false
			$ActItemTimer.start()
			if ($Sprite_Gun.get_global_rotation_degrees() >= 90 && $Sprite_Gun.get_global_rotation_degrees() < 180) || ($Sprite_Gun.get_global_rotation_degrees() >= -180 && $Sprite_Gun.get_global_rotation_degrees() < -90):
				$Sprite_Player.set_flip_h(true)
				sprite_flip = true
			elif ($Sprite_Gun.get_global_rotation_degrees() >= 0 && $Sprite_Gun.get_global_rotation_degrees() < 90) || ($Sprite_Gun.get_global_rotation_degrees() >= -90 && $Sprite_Gun.get_global_rotation_degrees() < 0) :
				$Sprite_Player.set_flip_h(false)
				sprite_flip = false
				
			if actitem == ACTITEM.TACK:
				var g = TACK_SCENE.instance()
				get_parent().add_child(g)
				g.parent = get_instance_id()
				if sprite_flip:
					g.start_at($Sprite_Gun.get_global_rotation(),Vector2(global_position.x-32,global_position.y-4))  
				else :
					g.start_at($Sprite_Gun.get_global_rotation(),Vector2(global_position.x+32,global_position.y-4))  
			elif actitem == ACTITEM.GUM:
				var g = GUM_SCENE.instance()
				get_parent().add_child(g)
				g.parent = get_instance_id()
				if sprite_flip:
					g.start_at($Sprite_Gun.get_global_rotation(),Vector2(global_position.x-32,global_position.y-4))  
				else :
					g.start_at($Sprite_Gun.get_global_rotation(),Vector2(global_position.x+32,global_position.y-4))
				

func _on_ActItemTimer_timeout():
	can_use = true

func _on_Hitbox_area_entered(area):
	if area.get("TYPE") != null && area.get("TYPE") == "HOLE":
		falling = true
	if area.get("TYPE") != null && area.get("TYPE") == "FLOORHOLE":
		shaking = true
	if area.get("TYPE") != null && area.get("TYPE") == "FLOORGUM":
		SLOW = true
	if area.get("TYPE") != null && area.get("TYPE") == "FLOORTACK":
		TACK_IN = true 
		if $TackTimer.is_stopped():
			TACK_HURT = true
	if area.get("TYPE") != null && area.get("TYPE") == "GUMACT":
		if area.parent != get_instance_id():
			area._boom()
	if actitem == ACTITEM.NULL && area.get("TYPE") != null && area.get("TYPE") == "ACTITEM" && area.collectible:
					actitem = area.get("NAME")
					area.queue_free()
	elif actitem != ACTITEM.NULL && area.get("TYPE") != null && area.get("TYPE") == "ACTITEM" && area.collectible:
				if actitem == ACTITEM.TACK:
					var a = ITEM_TACK_SCENE.instance()
					get_parent().add_child(a)
					a.start_at(Vector2(global_position.x,global_position.y))
				elif actitem == ACTITEM.GUM:
					var a = ITEM_GUM_SCENE.instance()
					get_parent().add_child(a)
					a.start_at(Vector2(global_position.x,global_position.y))
				actitem = area.get("NAME")
				area.queue_free()
	if area.get("TYPE") != null && area.get("TYPE") == "ITEM" && area.collectible:
					if area.get("NAME") == ITEM.ERASER:
						eraser_get += 1
						area.queue_free()
					elif area.get("NAME") == ITEM.GLUE:
						glue_get += 1
						area.queue_free()
	if area.get("DAMAGE") != null and area.get("TYPE") == "BULLET" and area.parent != get_instance_id():
			takeDamage(area.get("DAMAGE"))
			area.queue_free()

func _on_Hitbox_area_exited(area):
	if area.get("TYPE") != null && area.get("TYPE") == "FLOORHOLE":
		shaking = false
	if area.get("TYPE") != null && area.get("TYPE") == "FLOORGUM":
		SLOW = false
	if area.get("TYPE") != null && area.get("TYPE") == "FLOORTACK":
		TACK_IN = false
		
func init(start_position):#nickname, start_position, is_slave):
	#$GUI/Nickname.text = nickname
	global_position = start_position
	#if is_slave:
		#$Sprite.texture = load('res://player/player-alt.png')


