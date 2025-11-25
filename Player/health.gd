extends ProgressBar

var health: float
var MAXHEALTH: float = 100.0
var healTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAXHEALTH / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = health
	if health < MAXHEALTH and healTimer > 5.0:
		changeHealth(1)
	healTimer += delta

func changeHealth(val: float):
	health += val
	if val < 0: healTimer = 0
	if health > MAXHEALTH:
		health = MAXHEALTH
	if health <= 0:
		die()
		
func die() -> void:
	print("You Died")
