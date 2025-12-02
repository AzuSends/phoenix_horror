class_name Enemy
extends CharacterBody3D

#get the player from the PlayerClass in PlayerMovement.gd
@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var parent = get_parent()

#no anims yet :(
@onready var animation: AnimatedSprite3D = $Sprites
@onready var sprites: AnimatedSprite3D = $Sprites
@onready var state_machine: State_Machine = $State_Machine
@onready var active_sight: Area3D = $State_Machine/ActiveSight
@onready var sight: Area3D = $State_Machine/Sight
@onready var attack_sight: Area3D = $State_Machine/AttackSight
@onready var attack_area: CollisionShape3D = $Attack/HitBox/CollisionShape3D
@onready var fireSpreader: GridMap = $"/root/Node3D/Main/Level"

#export variable section :3
@export_category("Enemy Stats")
@export var home_point: Node3D
@export var attack_cooldown: float = 3.0
const maxHealth = 4.0
@export var health: float = maxHealth

var move_dir : Vector3
var has_attacked: bool
var can_attack: bool = true
var can_change_dir: bool
var chase_dir_timer: float = 1.0
var is_staggered: bool = false
var damage: float = 20.0	#damage enemy deals to player
const resetSpreadTimer = 10
var spreadTimer = resetSpreadTimer
var caughtFire = false; #Flag for if monster has come into contact with fire

const MOVE_SPEED: float = 4

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var prevPos : Vector3
var stuckThreshold = 0.01

func _ready():
	await get_tree().process_frame

func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept"):
			var random_position := Vector3.ZERO
			random_position.x = randf_range(10.0, 60.0)
			random_position.z = randf_range(4.0, 55.0)
			navigation_agent_3d.set_target_position(random_position)

func _physics_process(_delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * 5.0
	
	if global_position.distance_to(prevPos) < stuckThreshold and velocity.length() > stuckThreshold:
		velocity.y = 15.0
	
	prevPos = global_position
	if not self.is_on_floor():
		self.velocity += get_gravity() * _delta 
	interpret_state(_delta)
	if caughtFire == true:
		attemptSpread(_delta)
	else:
		tryCatchOnFire()
	move_and_slide()
	
func attemptSpread(delta):
	spreadTimer -= delta
	if spreadTimer <= 0:
		print("attempting to fan flames")
		var rng = RandomNumberGenerator.new()
		var cellLocation = fireSpreader.findCellFromLocation(global_position)
		var fireCell = fireSpreader.fireGrid[cellLocation]
		print(fireCell["flame"].getFireState())
		if rng.randi_range(1, 3) == 3:
			if not fireCell["flame"].getFireState():
				fireSpreader.startFire(cellLocation)
				print("spreading fire")
			else:
				fireSpreader.fireGrid[cellLocation]["flame"].tryIntensifyFlame()
				print("intensifying fire")
		else:
			print("failed spread")
		spreadTimer = resetSpreadTimer
		
func tryCatchOnFire():
	var nearbyFire = fireSpreader.findFireFromLocation(global_position)
	if nearbyFire != null:
		caughtFire = true;
	
		
func interpret_state(_delta):
	#can_attack = false
	has_attacked = false
	can_change_dir = true
	match state_machine.current_state:
		State_Machine.state.IDLE:
			#make the enemy not move
			#print("Idle")
			self.animation.play("Idle")
			#code for idle goes here (get rid of pass)
			if active_sight.has_overlapping_bodies() and not is_staggered: 
				state_machine.current_state = State_Machine.state.CHASE
			#for if u wanna drop down onto the enemy lol
				
	match state_machine.current_state:
		State_Machine.state.CHASE:
			#print("Chasing player")
			#look at the player
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			self.animation.play("Chase")
			#code for chase ig??
			if sight.has_overlapping_bodies():
				#chase player
				var direction = player.global_position - self.global_position
				var new_velocity = direction.normalized() * MOVE_SPEED
				self.velocity = new_velocity
				if can_change_dir:
					can_change_dir = false
					await get_tree().create_timer(chase_dir_timer).timeout
					can_change_dir = true
			else:
				state_machine.current_state = State_Machine.state.IDLE
				self.velocity = Vector3.ZERO
			#check if the player can be attacked
			if attack_sight.has_overlapping_bodies() and can_attack: 
				state_machine.current_state = State_Machine.state.ATTACK
			else:
				#state_machine.current_state = State_Machine.state.IDLE
				self.velocity = Vector3.ZERO
	match state_machine.current_state:
		State_Machine.state.ATTACK:
			#start the animation:
			#print("Attacking Player")
			self.animation.play("Attack")
			#set the attack area to enabled
			attack_area.disabled = false
			
	match state_machine.current_state:
		State_Machine.state.PAIN:
			self.animation.play("Pain")
			pass
	match state_machine.current_state:
		State_Machine.state.DEAD:
			pass

func get_randomized_dir() -> Vector3:
	look_at(Vector3(player.global_position), Vector3.UP)
	var direction: Vector3 = player.global_position - self.global_position
	direction.y = self.global_position.y
	return direction.normalized()

func _on_sprites_animation_finished() -> void:
	#print("does it ever get here")
	if animation.animation == "Attack":
		can_attack = false
		attack_area.disabled = true
		state_machine.current_state = State_Machine.state.CHASE
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func take_damage(amount: float) -> void:
	state_machine.current_state = State_Machine.state.PAIN
	self.animation.play("Pain")
	is_staggered = true
	print("enemy hurt")
	health -= amount
	print(health)
	if health > 0:
		await get_tree().create_timer(2.0).timeout
		is_staggered = false
		state_machine.current_state = State_Machine.state.CHASE
	if health <= 0:
		state_machine.current_state = State_Machine.state.DEAD
		is_staggered = true
		can_attack = false
		await get_tree().create_timer(2.0).timeout
		enemy_dead()

func enemy_dead() -> void:
	caughtFire = false
	spreadTimer = resetSpreadTimer
	process_mode = Node.PROCESS_MODE_DISABLED
	print("monster is dead (for now...)")
	
func reviveDead():
	health = maxHealth
	is_staggered = false
	can_attack = true
	state_machine.current_state = State_Machine.state.IDLE
	process_mode = Node.PROCESS_MODE_INHERIT
	print("monster brought back to life")

#upon the hitbox being entered, the player will take damage
func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player3d":
		var playerHealth = body.get_node("Health")
		playerHealth.changeHealth(-damage)
