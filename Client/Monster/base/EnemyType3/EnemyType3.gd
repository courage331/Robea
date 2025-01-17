extends KinematicBody2D

const BULLET_SCENE = preload("res://Monster/base/EBullet.tscn")
var SPEED = 40

const TYPE = "ENEMY"
const DAMAGE = 10

var hitstun = 0
var health = 10

var target = null
var can_shoot = true

var movedir = Vector2(0,0)
var knockdir = Vector2(0,0)
var spritedir = "down"

var GLUE_VAR = 1

var hitmask = 1
var hitTimer = 0

var limit_l = 0
var limit_r = 0
var limit_u = 0
var limit_d = 0

var movetimer_length = 15
var movetimer = 0
var grid_position = Vector2(0,0)


slave var Shoot_signal = false
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
		#rset_unreliable('Sposition', position)
		#rset_unreliable('Shealth', health)
		#rset_unreliable('Shoot_signal', can_shoot)
		for body in $ChaseArea.get_overlapping_bodies():
			if body.get("TYPE") == "PLAYER" and body.grid_position == grid_position:
				movedir = Vector2(body.global_position.x-global_position.x, body.global_position.y-global_position.y)
				target = body
		
		if target:
			var target_dir = (target.global_position - global_position).normalized()
			$ESprite_Gun.global_rotation = target_dir.angle()
			shoot()
		
		if health <= 0:
			get_parent().EnemyCount -= 1
			rset_unreliable('death', true)
			queue_free()
	else:
		position = Sposition
		health = Shealth
		damage_loop()
		if death:
			get_parent().EnemyCount -= 1
			queue_free()
	

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
			if n1.distance_to(n2) <= 96:
				SPEED = 0
			else:
				SPEED = 20
			motion = movedir.normalized() * SPEED * GLUE_VAR
		else:
			SPEED = 40
			motion = movedir.normalized() * SPEED * GLUE_VAR
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
	
	"""for body in $Hitbox.get_overlapping_bodies():
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") == "BULLET":
			if body.glue:
				GLUE_VAR = 0.5
				$GlueTimer.start()
			hitTimer = 1
			health -= body.get("DAMAGE")
			hitstun = 5
			SPEED = 0
			body.queue_free()"""
	

func _on_ChaseArea_body_exited(body):
	if body == target:
		target = null

func shoot():
	if can_shoot:
		rset_unreliable('Shoot_signal', false)
		can_shoot = false
		$GunTimer.start() # 무기 연사(장전) 시간 
		var b = BULLET_SCENE.instance()
		get_parent().add_child(b)
		b.start_at($ESprite_Gun.get_global_rotation(),get_node("ESprite_Gun/EFirePosition").get_global_position()) # 총알 생성 

func _on_GunTimer_timeout():
	rset_unreliable('Shoot_signal', true)
	can_shoot = true


func _on_DirTimer_timeout():
	movedir = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	if !target:
		$ESprite_Gun.global_rotation = movedir.angle()


func _on_GlueTimer_timeout():
	$GlueTimer.stop()
	GLUE_VAR = 1


func _on_Hitbox_area_entered(area):
	if hitstun == 0 and area.get("DAMAGE") != null and area.get("TYPE") == "BULLET":
			if area.glue:
				GLUE_VAR = 0.5
				$GlueTimer.start()
			hitTimer = 1
			health -= area.get("DAMAGE")
			hitstun = 5
			SPEED = 0
			area.queue_free()
