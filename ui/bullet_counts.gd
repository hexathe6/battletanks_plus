extends HBoxContainer

func add_count(type):
	var x = HBoxContainer.new()
	var icon_c = Panel.new()
	icon_c.custom_minimum_size = Vector2(64,64)
	var icon = TextureRect.new()
	icon.texture = load("res://bullets/player_" + type + ".png")
	icon.rotation = PI/2
	icon.position.x = 64
	icon_c.add_child(icon)
	var label = Label.new()
	label.text = str(global.bullet_counts[global.bullet_enum[type]])
	add_child(x)
	x.add_child(icon_c)
	x.add_child(label)

func _ready():
	add_count("basic")
	add_count("spray")

func _process(delta):
	for i in range(0,global.bullet_counts.size()):
		get_child(i).get_child(1).text = str(global.bullet_counts[i])
