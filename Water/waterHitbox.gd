extends Area3D

@onready var hitSFX = $"/root/Node3D/Main/Player3d/Head/Hitbox/HitSound"
@onready var playerWaterController: CPUParticles3D = $"/root/Node3D/Main/Player3d/Head/WaterController"
#$"../WaterController"
var player
const damage = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage") and playerWaterController.isHoly == true:
		body.take_damage(damage)
		hitSFX.play()

func toggleHitboxOff():
	var hitboxVolume = $CollisionShape3D
	hitboxVolume.set_deferred("disabled", true)
	
func toggleHitboxOn():
	var hitboxVolume = $CollisionShape3D
	hitboxVolume.set_deferred("disabled", false)
