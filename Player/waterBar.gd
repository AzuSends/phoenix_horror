extends ProgressBar

var waterController
func _ready() -> void:
	waterController = get_node("../WaterController")


func _process(_delta: float) -> void:
	self.value = waterController.waterStored
	if waterController.isHoly == true:
		self.get("theme_override_styles/fill").bg_color = Color(0.53, 0.89, 0.99)
	else:
		self.get("theme_override_styles/fill").bg_color = Color(0.02, 0.36, 0.52)
