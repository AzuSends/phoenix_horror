extends GridMap


var FireInstance = preload("res://Fire/FireInstance.gd")
var fireScene = preload("res://Fire/Fire.tscn")
	
	# Called when the node enters the scene tree for the first time.
var pheonixFire = FireInstance.fireInstance
var startingPosition
var fireOrigin 
const fireDistance = 3
var timeSinceFireUpdate = 0
const fireSpreadTimer = 2
const spreadIntensity = 3
	
var fireGrid = get_used_cells()

var player
var playerWaterController
var instances = {}


	
func _ready():
	##init grid
	var gridThrowaway = {}
	for location in fireGrid:
		# location goes from smallest to largest in x and z coordinates
		var globalPosition = to_global(location)
		gridThrowaway[globalPosition] = {"flame": pheonixFire.new(globalPosition), "neighbors": []}
		instances[globalPosition] = fireScene.instantiate()
		add_child(instances[globalPosition])
		instances[globalPosition].position.x = globalPosition.x
		instances[globalPosition].position.y = globalPosition.y + 2.0
		instances[globalPosition].position.z = globalPosition.z
		instances[globalPosition].visible = false
		
	startingPosition = to_global(fireGrid.pick_random())
	fireGrid = gridThrowaway
	startFire(startingPosition)
	
	##finding & assigning neighbors
	for location in fireGrid.keys():
		for potentialNeighbor in fireGrid.keys():
			if location == potentialNeighbor: continue
			if location.distance_to(potentialNeighbor) <= fireDistance:
				fireGrid[location]["neighbors"].append(potentialNeighbor)
	player = get_node("../Player3d")
	
	playerWaterController = get_node("../Player3d/Head/WaterController")
	playerWaterController.water.connect(_on_water)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceFireUpdate+= delta
	
	if (timeSinceFireUpdate >= fireSpreadTimer):
		
		for location in fireGrid:
			
			var fire = fireGrid[location]["flame"]
			setOnFire(fire, location)
	
		timeSinceFireUpdate = 0
		#print("____")
		#debugPrintFires()
		

func setOnFire(flame, location):
	if flame.getIntensity() < spreadIntensity:
		flame.tryIntensifyFlame() 
		return
	for neighbor in fireGrid[location]["neighbors"]:
		if fireGrid.has(neighbor):
			if randi_range(1,16) == 16 and fireGrid[neighbor]["flame"].getIntensity() == 0:
				startFire(neighbor);

	flame.tryIntensifyFlame()


	
#NOTE: for the water thingy, you can call this function to get the location, 
#assing it to a var then do fireGrid[var]["flame"].reduceFlame() or .setIntensity(0)
func findFireFromLocation(location: Vector3):
	const distanceGap = 8
	var closest = Vector3.INF
	var closestInDist = location.distance_to(closest)
	for fireLocation in fireGrid:
		if fireGrid[fireLocation]["flame"].getFireState() == true:
			var newDist = location.distance_to(fireLocation)
			if newDist < closestInDist:
				closestInDist = newDist
				closest = fireLocation
		
	
	#mouse is way too far from flame to have any effect, dont return the object	
	#print(closestInDist)
	
	if closestInDist > distanceGap:
		return null
	
	return closest

func _on_water():
	var closestFire = findFireFromLocation(player.position)
	if (closestFire != null):
		putOutFire(closestFire)
		
		#print("CLOSTEST FIRE: ", closestFire)

#NOT YET IMPLIMENTED, CAN DO LATER
	# on receive signal of splashing water on CELL, call reduceFlame() on CELL
	# update partsOnFire and fireGrid accordingly
	
	#extra error handling and abstraction 
func startFire(location):
	fireGrid[location]["flame"].setIntensity(1)
	if fireGrid[location]["flame"].getFireState() == true:
		instances[location].visible = true
func putOutFire(location):
	fireGrid[location]["flame"].setIntensity(0)
	if fireGrid[location]["flame"].getFireState() == false:
		instances[location].visible = false


func debugPrintFires():
	for location in fireGrid.keys():
		if fireGrid[location]["flame"].getIntensity() >= 3:
			print(location, ": ", fireGrid[location]["flame"])
			#", ", fireGrid[location]["neighbors"])
