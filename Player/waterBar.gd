extends ProgressBar

var waterController
func _ready() -> void:
	waterController = get_node("../WaterController")


func _process(_delta: float) -> void:
	self.value = waterController.waterStored
