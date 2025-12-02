extends CPUParticles3D
var waterOn = false
var fillOn = false
var waterStored = 100
var waterMax = 100
signal water;

@onready var waterPool: MeshInstance3D = $"../../../WaterPool"
@onready var cross: Node3D = $"../../../BlessingSiteNode"
@onready var player: CharacterBody3D = $"../.."
var bucketTimer = 0.0;
var useRate = 0.25;
var fillRate = 1.0;
var waterHitbox
var isHoly = false;

func _ready() -> void:
	self.emitting = false;
	waterHitbox = $"../Hitbox"
	waterHitbox.toggleHitboxOff()
	print(waterHitbox.name)
	
func _process(delta: float) -> void:
	bucketTimer += delta
	if (waterOn == true and fillOn == false and waterStored > 0):
		self.emitting = true;
		waterStored -= useRate;
	else:
		self.emitting = false;
		
	if (fillOn == true):
		waterStored += fillRate
	
	if (waterStored >= waterMax):
		fillOn = false
	
func _unhandled_input(event) -> void:	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if bucketTimer > 1:
				waterHitbox.toggleHitboxOn()
				bucketTimer = 0
				waterOn = !waterOn;
				await get_tree().create_timer(0.25).timeout
				water.emit()
				waterOn = !waterOn;
				waterHitbox.toggleHitboxOff()
				
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if (waterPool.position.distance_to(player.position) < 5):
				fillOn = !fillOn
				isHoly = false
			
			elif (cross.position.distance_to(player.position) < 5):
				isHoly = true

func _do_fill():
	pass
