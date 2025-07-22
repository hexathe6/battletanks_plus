extends CharacterBody2D
class_name Player_tank

func move(x,y):
	move_and_collide(Vector2(x,y).rotated(rotation))
func do_rotate(to,by):
		rotate(lerp_angle(rotation,to,by)-rotation)

@onready var bullet_scene = preload("res://bullet.tscn")

func shoot(type):
	var b = func(x,p):
		@warning_ignore("confusable_local_declaration")
		var b = bullet_scene.instantiate()
		b.player = 0
		b.rot = rotation + x
		b.rotation = rotation + x
		b.position = position + Vector2(0,-50).rotated(rotation + x/2)
		b.variant = p
		get_parent().add_child(b)
	if type == "basic":
		if global.bullet_counts[0] is int:
			if global.bullet_counts[0] == 0: return
			global.bullet_counts[0] -= 1
		b.call(0,"basic")
	if type == "spray":
		if global.bullet_counts[1] is int:
			if global.bullet_counts[1] == 0: return
			global.bullet_counts[1] -= 1
		var r = 0.7
		var n = 3
		for i in range(0,n):
			b.call(-r/2 + r*i/n,"spray")

var player = 0
var speed = 2
var rot = 0.05
var bullet = global.bullet_enum_[0]
var health : float = 3
var state = "alive"

func remove_health(x):
	health -= x
	if health < 0:
		health = 0
		state = "dead"

func _ready():
	global.player = self

var moving = false
# current dev keyboard only sends a max of two keys at once;
# this entire system probably needs to be adjusted for other kbs
var moving_keys = [null,null]
func movkey_push(dir):
		if moving_keys[0] != null: moving_keys[1] = dir
		else: moving_keys[0] = dir
func movkey_unpush(dir):
		if moving_keys[0] == dir:
			moving_keys[0] = moving_keys[1]
			moving_keys[1] = null
		if moving_keys[1] == dir:
			moving_keys[1] = null
func movkey_calc():
	if moving_keys == [null,null]: return 0
	if moving_keys[0] == null: return moving_keys[1]
	if moving_keys[1] == null: return moving_keys[0]
	return lerp_angle(moving_keys[0],moving_keys[1],0.5) *\
		1#abs(Vector2(0,-1).rotated(moving_keys[0]).dot(Vector2(0,-1).rotated(moving_keys[1])))
var moving_dir = 0.0
func _process(delta):
	moving = false
	if(Input.is_action_pressed("move")):
		moving = true
	if(Input.is_action_just_pressed("up")): movkey_push(0)
	if(Input.is_action_just_pressed("down")): movkey_push(PI)
	if(Input.is_action_just_pressed("left")): movkey_push(-PI/2)
	if(Input.is_action_just_pressed("right")): movkey_push(PI/2)
	if(Input.is_action_just_released("up")): movkey_unpush(0)
	if(Input.is_action_just_released("down")): movkey_unpush(PI)
	if(Input.is_action_just_released("left")): movkey_unpush(-PI/2)
	if(Input.is_action_just_released("right")): movkey_unpush(PI/2)
	if(moving and state == "alive"):
		do_rotate(movkey_calc(),rot)
		move(0,-speed)
	
	if(Input.is_action_pressed("one")):
		bullet = global.bullet_enum_[0]
	if(Input.is_action_pressed("two")):
		bullet = global.bullet_enum_[1]
	
	if(Input.is_action_just_pressed("shoot")):
		shoot(bullet)
	
	for i in $detector.get_overlapping_bodies():
		if i is TileMapLayer:
			var x : float = 0
			@warning_ignore("confusable_local_declaration")
			var xf = func(x,y):
					if x > 0:
						return x
					else:
						return y
			x = xf.call(x,global.get_data_at_tile(position + Vector2(-64,0),"health_drain"))
			x = xf.call(x,global.get_data_at_tile(position + Vector2(64,0),"health_drain"))
			x = xf.call(x,global.get_data_at_tile(position + Vector2(0,-64),"health_drain"))
			x = xf.call(x,global.get_data_at_tile(position + Vector2(0,64),"health_drain"))
			remove_health(x * delta)
