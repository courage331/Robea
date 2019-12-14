extends Area2D


export var BULLET_SPEED = 250

const TYPE = "BULLET"
var DAMAGE = 2.5

var glue = false
var eraser = false

var bounce_timer = 1

var parent = null

var velocity = Vector2()
var check_master = false

func start_at(dir, pos):
	$Lifetime.start()
	set_global_rotation(dir)
	set_global_position(pos)
	velocity = Vector2(BULLET_SPEED, 0).rotated(dir)
	if check_master:
		get_parent().get_node("ScreenShake").screen_shake(0.1,1,100)

func _ready():
	set_process(true)

func _process(delta):
	set_global_position(get_global_position() + velocity * delta)
	
	
func destroy():
	queue_free()

func _on_Lifetime_timeout():
	destroy()

func _on_Hitbox_body_entered(body):
		if eraser:
			if body.get_name() == "WallLeft" || body.get_name() == "WallRight":
				if get_global_rotation_degrees() < 0:
					set_global_rotation_degrees(-(180 - abs(get_global_rotation_degrees())))
				elif get_global_rotation_degrees() > 0:
					set_global_rotation_degrees(180 - get_global_rotation_degrees())
			elif body.get_name() == "WallUp" || body.get_name() == "WallDown":
					set_global_rotation_degrees(-get_global_rotation_degrees())
			elif body.get_name() == "TileMap" :
				if get_global_rotation_degrees() < 0:
					set_global_rotation_degrees(get_global_rotation_degrees() + 180)
				elif get_global_rotation_degrees() < 0:
					set_global_rotation_degrees(get_global_rotation_degrees() - 180)
			velocity = Vector2(BULLET_SPEED, 0).rotated(get_global_rotation())
		else:
			if body.get_name() == "WallLeft" || body.get_name() == "WallRight" || body.get_name() == "WallUp" || body.get_name() == "WallDown" || body.get_name() == "TileMap":
				queue_free()


