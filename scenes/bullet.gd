extends Node2D

@export var init_position: Vector2
@export var speed := 600.0
@export var player_id := 0

var lifetime := 3.0
var expball_pre = preload("res://scenes/exp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	position = init_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.from_angle(rotation) * speed * delta
	lifetime -= delta
	if lifetime <= 0.0 and multiplayer.is_server():
		queue_free()

@rpc("any_peer")
func delete_this():
	queue_free()

func _on_hitbox_area_entered(area):
	var body = area.get_parent()
	if body is Target:
		if player_id == multiplayer.get_unique_id():
			body.damaged.emit()
			delete_this.rpc_id(1)
