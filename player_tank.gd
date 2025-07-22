extends CharacterBody2D

func move(x,y):
	move_and_collide(Vector2(x,y).rotated(rotation))
func do_rotate(to,by):
		rotate(lerp_angle(rotation,to,by)-rotation)

@onready var bullet_scene = preload("res://bullet.tscn")

func shoot(type):
	var b = func(x,p):
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

var moving = false
func _process(delta):
	moving = false
	if(Input.is_action_pressed("up")):
		moving = true
		do_rotate(0,rot)
	if(Input.is_action_pressed("down")):
		moving = true
		do_rotate(PI,rot)
	if(Input.is_action_pressed("left")):
		moving = true
		do_rotate(-PI/2,rot)
	if(Input.is_action_pressed("right")):
		moving = true
		do_rotate(PI/2,rot)
	if(moving):
		move(0,-speed)
	
	if(Input.is_action_pressed("one")):
		bullet = global.bullet_enum_[0]
	if(Input.is_action_pressed("two")):
		bullet = global.bullet_enum_[1]
	
	if(Input.is_action_just_pressed("shoot")):
		shoot(bullet)
	pass
