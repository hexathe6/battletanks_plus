extends Node

var bullet_enum = {"basic": 0, "spray": 1}
var bullet_enum_ = {0: "basic", 1: "spray"}
var bullet_counts = ["inf", 5]

var iframes = 30

var player : Player_tank = null
var tilemap : TileMapLayer = null

func get_data_at_tile(pos,data):
	return tilemap.get_cell_tile_data(tilemap.local_to_map(pos))\
		   .get_custom_data(data)

func eq(a,b):
	if a.get_class() == b.get_class():
		return a == b
	return false
