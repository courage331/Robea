extends KinematicBody2D

var SPEED = 40

const TYPE = "ENEMY"
const DAMAGE = 10

var hitstun = 0
var health = 10

var target = null
var movedir = Vector2(0,0)
var knockdir = Vector2(0,0)
var spritedir = "down"

var limit_l = 0
var limit_r = 0
var limit_u = 0
var limit_d = 0

var movetimer_length = 15
var movetimer = 0
var grid_position = Vector2(0,0)
var hitmask = 1
var dying = false

slave var Sposition = Vector2()
slave var Shealth = health
slave var death = false

	

func _ready():
	$Animation.play("default")
	$DirTimer.start()
	movedir = Vector2(rand_range(-1, 1), rand_range(-1, 1))


	
func _physics_process(delta):
	if get_tree().is_network_server():
		movement_loop()
		damage_loop()
		if !dying:
			rset_unreliable('Sposition', position)
			rset_unreliable('Shealth', health)
		
		for body in $ChaseArea.get_overlapping_bodies():
			if body.get("TYPE") == "PLAYER" and body.grid_position == grid_position:
				movedir = Vector2(body.global_position.x-global_position.x, body.global_position.y-global_position.y)
				target = body
				
		if health <= 0:
			get_parent().EnemyCount -= 1
			if !dying:
				rset_unreliable('death', true)
			queue_free()
				
	else:
		position = Sposition
		health = Shealth
		damage_loop()
		if death:
			get_parent().EnemyCount -= 1
			queue_free()
		

func start_at(pos):
	set_position(pos)


func movement_loop():
	var motion
	if global_position.x <= limit_l || global_position.x >= limit_r || global_position.y >= limit_d || global_position.y <= limit_u:
			hitstun = 30
			movedir = -movedir
			knockdir = movedir
	if hitstun == 0:
		if target:
			var n1 = Vector2(target.global_position.x,target.global_position.y)
			var n2 = Vector2(global_position.x,global_position.y)
			SPEED = 50
			motion = movedir.normalized() * SPEED
		else:
			SPEED = 25
			motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * SPEED * 3

	move_and_slide(motion, Vector2(0,0))
	
			
func anim_switch(animation):
	var newanim = str(animation, spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)

func damage_loop():
	if hitstun > 0:
		hitstun -= 1
		hitmask -= 0.01
		$Sprite.modulate = Color(hitmask, 0, 0)
	else:
		hitmask = 1
		hitstun = 0
		$Sprite.modulate = Color(1, 1, 1)
		
	for body in $Hitbox.get_overlapping_bodies():
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") == "PLAYER":
			hitstun = 10
			knockdir = Vector2(global_position.x - body.global_position.x, global_position.y - body.global_position.y)
	
	

	
	

func _on_DirTimer_timeout():
	movedir = Vector2(rand_range(-1, 1), rand_range(-1, 1))


func _on_Hitbox_area_entered(area):
	if hitstun == 0 and area.get("DAMAGE") != null and area.get("TYPE") == "BULLET":
			health -= area.get("DAMAGE")
			hitstun = 5
			SPEED = 0
			area.destroy()
