extends CPUParticles3D
var waterOn;
signal water;

func _ready() -> void:
	self.emitting = false;

	


func _process(_delta: float) -> void:
	if (waterOn == true):
		self.emitting = true;
		water.emit()
	else:
		self.emitting = false;
	
func _unhandled_input(event) -> void:	
	
	if event is InputEventMouseButton:
		waterOn = !waterOn;
