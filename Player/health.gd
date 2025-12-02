extends ProgressBar

var health: float
var MAXHEALTH: float = 100.0
var healTimer = 0
var isDead = false

@onready var player: CharacterBody3D = $".."
@onready var pov: Camera3D = $"../Head/Camera3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAXHEALTH

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
	player.disableMovement()
	if !isDead:
		isDead = true
		set_physics_process(false)
		camera_transition(player, 1.0, 0.5)
		await get_tree().create_timer(2.5).timeout
		get_tree().reload_current_scene()
		#disable player controls and display death screen
	

func camera_transition(node, amount: float, duration: float) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
	var target_position = player.global_position + Vector3(0, -1, 0)
	print("tweening")
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(pov, "rotation_degrees:z", -30, 1.0)
	tween.tween_property(node, "position", target_position, duration)
	#fade to black
	#TODO: make this work lol. idk why the canvas layer is interfereing with player movement :p
	#tween.tween_property($"../CanvasLayer/Control/ColorRect", "color", Color(0, 0, 0, 1), 2.7)
