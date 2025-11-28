extends Node3D

#
var minInterval = 6
var maxInterval = 20
var elapsedInterval = 0

#Tracks active spawns, object pointer if occupied, null otherwise, always cleanup to null
var spawns = [null, null, null]

var loc1 = Vector3(0,0,0)
var loc2 = Vector3(0,0,0)
var loc3 = Vector3(0,0,0)
var spawnsLocation = [loc1, loc2, loc3]

var timeToSpawn = 10

var spawning = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#If already spawning we don't start another spawn till after it's finished
	if spawning == false:
		elapsedInterval += delta
	if elapsedInterval < minInterval:
		pass
	elif elapsedInterval > maxInterval:
		print("force spawn")
		doSpawn()
	else:
		trySpawn()

func trySpawn():
	if randi_range(1,500) == 500:
		doSpawn()

func doSpawn():
	elapsedInterval = 0
	spawning = true
	
	#Instantiate monster
	
	#Place at a valid spawn
	
	#Start spawn timer
	
	#After time elapsed give monster pathing behavior
	#(We'll likely connect path nodes manually to avoid complex pathing) 
	#(Pathing is something to tackle later tho)
	
	#reset interval, set spawning to false
	spawning = false
	pass
