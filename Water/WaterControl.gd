extends CPUParticles3D
var waterOn = false
var fillOn = false
var waterStored = 100
var waterMax = 100
signal water;

var waterPool;
var player


func _ready() -> void:
	self.emitting = false;
	#Signalling back and forth is at most as complicated as any other solution I though of :/ sozz
	waterPool = get_node("/root/Node3D/Main/WaterPool")

	player = get_node("/root/Node3D/Main/Player3d")
	

	


func _process(_delta: float) -> void:
	if (waterOn == true and fillOn == false and waterStored > 0):
		self.emitting = true;
		water.emit()
		waterStored -= .25;
	else:
		self.emitting = false;
		
	if (fillOn == true):
		waterStored += 1
	
	if (waterStored >= waterMax):
		fillOn = false
	
func _unhandled_input(event) -> void:	
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			waterOn = !waterOn;
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if (waterPool.position.distance_to(player.position) < 5):
				fillOn = !fillOn
				

func _do_fill():
	pass
