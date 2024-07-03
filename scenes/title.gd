extends CanvasLayer

signal start_pressed
signal room_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	start_pressed.emit($entername.text)
	hide()


func _on_room_pressed():
	room_pressed.emit()
	hide()
