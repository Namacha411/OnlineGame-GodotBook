extends Node

const PORT = 1111
const SERVER_IP = "127.0.0.1"

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
	
@rpc("any_peer")
func tank_spawn():
	var tank = tank_pre.instantiate()
	var id = multiplayer.get_remote_sender_id()
	tank.name = str(id)
	$players.add_child(tank)

func _on_title_start_pressed(entername):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, PORT)
	multiplayer.multiplayer_peer = peer
	
	await multiplayer.connected_to_server
	tank_spawn.rpc_id(1)


func _on_title_room_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(on_new_player)
	multiplayer.peer_disconnected.connect(on_exit_player)

func on_new_player(player_id):
	print("enter player id: %d" % player_id)

func on_exit_player(player_id):
	print("exit player id: %d" % player_id)
