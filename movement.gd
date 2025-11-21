extends Node
var movement;
var SPEED = 5.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.use_accumulated_input = false
	movement = true

	


func _process(delta: float) -> void:
	if (movement == true):
		do_Move(delta)
	
	if Input.is_action_just_pressed("menu_open"):
		if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			movement = false
			
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			movement = true
func _unhandled_input(event) -> void:	
	
	if event is InputEventMouseMotion:
		if (movement == true):
			self.rotation.y -= event.relative.x * .005
			self.rotation.x -= event.relative.y * .005

func do_Move (delta: float) -> void:
	if Input.is_action_pressed("walk_right"):
		self.position += Vector3(cos(-self.rotation.y) * SPEED * delta, 0.0,sin(-self.rotation.y) * SPEED * delta)
	if Input.is_action_pressed("walk_left"):
		self.position -= Vector3(cos(-self.rotation.y) * SPEED * delta, 0.0,sin(-self.rotation.y) * SPEED * delta)
	if Input.is_action_pressed("walk_forward"):
		self.position -= Vector3(sin(self.rotation.y) * SPEED * delta, 0.0,cos(self.rotation.y) * SPEED * delta)
	if Input.is_action_pressed("walk_backward"):
		self.position += Vector3(sin(self.rotation.y) * SPEED * delta, 0.0,cos(self.rotation.y) * SPEED * delta)
