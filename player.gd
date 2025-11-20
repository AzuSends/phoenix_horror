extends Node
var movement;


func _ready() -> void:
	movement = true

	


func _process(delta: float) -> void:
	do_Move(delta)
	
			

func _unhandled_input(event) -> void:	
	
	if event is InputEventMouseMotion:

		self.rotation.y -= event.relative.x * .005
		self.rotation.x -= event.relative.y * .005

func do_Move (delta: float) -> void:
	if Input.is_action_pressed("walk_right"):
		self.position += Vector3(cos(-self.rotation.y) * 1.0 * delta, 0.0,sin(-self.rotation.y) * 1.0 * delta)
	if Input.is_action_pressed("walk_left"):
		self.position -= Vector3(cos(-self.rotation.y) * 1.0 * delta, 0.0,sin(-self.rotation.y) * 1.0 * delta)
	if Input.is_action_pressed("walk_forward"):
		self.position -= Vector3(sin(self.rotation.y) * 1.0 * delta, 0.0,cos(self.rotation.y) * 1.0 * delta)
	if Input.is_action_pressed("walk_backward"):
		self.position += Vector3(sin(self.rotation.y) * 1.0 * delta, 0.0,cos(self.rotation.y) * 1.0 * delta)
