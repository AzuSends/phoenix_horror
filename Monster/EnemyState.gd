class_name State_Machine
extends Node3D

@onready var parent = get_parent()

enum state {IDLE, CHASE, ATTACK, PAIN, DEAD}
var current_state = state.IDLE

func change_state(st):
	current_state = st
	match current_state:
		state.IDLE:
			parent.animation.play("Idle")
	match current_state:
		state.CHASE:
			parent.animation.play("Chase")
	match current_state:
		state.ATTACK:
			parent.animation.play("Attack")
	match current_state:
		state.PAIN:
			parent.animation.play("Pain")
	match current_state:
		state.DEAD:
			parent.animation.play("Dead")
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
