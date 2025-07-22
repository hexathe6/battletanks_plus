extends VBoxContainer

func _ready():
	get_node("health_bar_container").custom_minimum_size = Vector2(64,18)

func _process(delta):
	get_node("health_count/health_amt").text = str(int(floor(global.player.health)))
	get_node("health_bar_container/health_bar").size.x =\
		get_node("health_bar_container").size.x *\
		(global.player.health - floor(global.player.health - 0.001))
