extends CharacterBody2D

const ROT_SPEED = 1
const MOVE_SPEED = 200
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bullet_pre = preload("res://scenes/bullet.tscn")
var rotation_velocity := 0.0
var tank_exp := 0
var tank_exp_max := 10
var tank_level := 1
var player_id := 0

func _enter_tree():
	player_id = int(str(name))
	set_multiplayer_authority(player_id)
	
func _ready():
	if player_id == multiplayer.get_unique_id():
		$name.text = $/root/main/title/entername.text
	else:
		$camera.enabled = false
		set_physics_process(false)

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		rotation_velocity = direction * ROT_SPEED * delta
	else:
		rotation_velocity = move_toward(rotation_velocity, 0, ROT_SPEED)
	
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity = Vector2.from_angle($body.rotation) * MOVE_SPEED * direction_y * (-1)
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta * 10)
	$body.rotation += rotation_velocity
	$cannon.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		var bullet_position = position
		var bullet_rotation = $cannon.rotation
		var bullet_speed = clamp(6 + (tank_level - 1) * 0.2, 0, 12) * 100
		var bullet_scale = scale * 5
		shoot.rpc_id(1, bullet_position, bullet_rotation, bullet_scale, bullet_speed)
	move_and_slide()

@rpc("any_peer")
func shoot(bullet_position, bullet_rotation, bullet_scale, bullet_speed):
	var bullet = bullet_pre.instantiate()
	bullet.init_position = bullet_position
	bullet.rotation = bullet_rotation
	bullet.scale = bullet_scale
	bullet.speed = bullet_speed
	bullet.player_id = player_id
	bullet.name = str(randi())
	$/root/main/bullets.add_child(bullet)

func _on_area_area_entered(area):
	var body = area.get_parent()
	if body is Exp:
		body.queue_free()
		if player_id == multiplayer.get_unique_id():
			exp_add(1)

func exp_add(v):
	tank_exp += v
	if tank_exp_max <= tank_exp:
		tank_exp -= tank_exp_max
		tank_level += 1
		scale = Vector2(0.2, 0.2) + (tank_level - 1) * Vector2(0.015, 0.015)
		$camera.zoom = Vector2(1, 1) + (tank_level - 1) * Vector2(-0.01, -0.01)
		tank_exp_max = round(10 + (tank_level - 1) * 5)
	var expbar = $/root/main/ui/expbar
	var exp_label = $/root/main/ui/exp
	var level_label = $/root/main/ui/level
	expbar.value = tank_exp
	expbar.max_value = tank_exp_max
	exp_label.text = "%d / %d" % [tank_exp, tank_exp_max]
	level_label.text = "Lv %02d" % tank_level
