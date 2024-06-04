extends Node2D

var expball_pre = preload("res://scenes/exp.tscn")
var speed := 600.0
var lifetime := 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.from_angle(rotation) * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_hitbox_area_entered(area):
	var body = area.get_parent()
	if body is Target:
		body.queue_free()
		self.queue_free()
		for i in range(randi_range(3, 5)):
			var expball = expball_pre.instantiate()
			expball.position = body.position
			expball.lerp_position = body.position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
			$/root/main/exps.add_child.call_deferred(expball)
