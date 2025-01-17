extends Area2D

const FLOOR_SCENE = preload("res://Items/Active/Tack/act/Floor_Tack.tscn")
const TYPE = "TackACT"

export var BULLET_SPEED = 900
var act = false
var velocity = Vector2()
var parent = null

func start_at(dir, pos):
	$Sprite.play("default")
	set_process(true)
	set_global_position(pos)
	velocity = Vector2(BULLET_SPEED, 0).rotated(dir)
	
func _process(delta):
	set_global_position(get_global_position() + velocity * delta)
		

func _on_GumAct_body_entered(body):
	if body.get_name() == "TileMap":
		velocity = Vector2(0,0)
		var g = FLOOR_SCENE.instance()
		get_parent().add_child(g)
		g.start_at(Vector2(global_position.x,global_position.y))
		queue_free()


func _on_Sprite_animation_finished():
	velocity = Vector2(0,0)
	var g = FLOOR_SCENE.instance()
	get_parent().add_child(g)
	g.start_at(Vector2(global_position.x,global_position.y))
	queue_free()
