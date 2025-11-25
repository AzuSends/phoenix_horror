extends Area3D

@onready var health: ProgressBar = $"../Health"
var takeDamage = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if takeDamage == true: health.changeHealth(-1)

func _on_area_entered(area: Area3D) -> void:
	var fireHead = area.get_parent()
	if area != null and fireHead.visible == true:
		takeDamage = true
	else: takeDamage = false
