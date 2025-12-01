extends Area3D


var playerWaterController
var player
const damage = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Monster":
		body.take_damage(damage)

func toggleHitboxOff():
	var hitboxVolume = $CollisionShape3D
	hitboxVolume.set_deferred("disabled", true)
	
func toggleHitboxOn():
	var hitboxVolume = $CollisionShape3D
	hitboxVolume.set_deferred("disabled", false)
