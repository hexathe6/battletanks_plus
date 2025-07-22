extends Area2D
class_name Bullet

@export var player : int
@export var rot : float
@export var variant : String

var speed = 4

func _ready():
	if(variant == "basic"):
		$bullet_sprite.texture = load("res://bullets/player_basic.png")
	if(variant == "spray"):
		$bullet_sprite.texture = load("res://bullets/player_spray.png")

func _process(delta):
	position += Vector2(0,-speed).rotated(rotation)
	var bs = get_overlapping_bodies()
	for body in bs:
		if body.is_class("CharacterBody2D") and body.player != player:
			body.queue_free()
		queue_free()
