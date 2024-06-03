extends Node2D

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
