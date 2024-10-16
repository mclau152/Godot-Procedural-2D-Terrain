extends Camera2D



const ZOOM_SPEED = 1

var zoom_in = false

var zoom_out = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.




func _process(delta):

	if Input.is_action_just_released("Zoom_UP"):

		zoom_in = true

		zoom_out = false

	if Input.is_action_just_released("Zoom_DOWN"):

		zoom_out = true

		

	if zoom_in == true :

		zoom = lerp(zoom, zoom - Vector2(0.1,0.1), ZOOM_SPEED)

		

		zoom_in = false

		



	if zoom_out == true :

		zoom = lerp(zoom, zoom + Vector2(0.1,0.1), ZOOM_SPEED)

		

		zoom_out = false
