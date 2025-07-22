extends Node

var bullet_enum = {"basic": 0, "spray": 1}
var bullet_enum_ = {0: "basic", 1: "spray"}
var bullet_counts = ["inf", 5]

func eq(a,b):
	if a.get_class() == b.get_class():
		return a == b
	return false
