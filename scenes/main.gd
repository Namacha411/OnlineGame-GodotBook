extends Node

var tank_pre = preload("res://scenes/tank.tscn")
var target_pre = preload("res://scenes/target.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		var target = target_pre.instantiate()
		target.position = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
		$targets.add_child(target)
		await get_tree().create_timer(1).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_title_start_pressed(entername):
	var tank = tank_pre.instantiate()
	tank.get_node("name").text = entername
	$players.add_child(tank)
