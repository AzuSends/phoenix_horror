extends GridMap


var FireInstance = preload("res://Fire/FireInstance.gd")
var fireScene = preload("res://Fire/Fire.tscn")
	
	# Called when the node enters the scene tree for the first time.
var pheonixFire = FireInstance.fireInstance
var startingPosition
var fireOrigin 
const fireDistance = 3
var timeSinceFireUpdate = 0
const fireSpreadTimer = 0.5 #TODO: CHANGE TO 2 ONCE FIRESPREAD VISUAL IS FIXED
const spreadIntensity = 3
	
var fireGrid = get_used_cells()

var player
var playerWaterController
var instances = {}

enum fireState {NONE, BURNING, SMOULDERING} #Smouldering will stop a fire from instantly reigniting with a lockout timer

	
func _ready():
	##init grid
	var gridThrowaway = {}
	for location in fireGrid:
		#print(location)
		# location goes from smallest to largest in x and z coordinates
		var globalPosition = to_global(location)
		gridThrowaway[globalPosition] = {"flame": pheonixFire.new(globalPosition), "neighbors": []}
		instances[globalPosition] = fireScene.instantiate()
		add_child(instances[globalPosition])
		instances[globalPosition].position.x = globalPosition.x
		instances[globalPosition].position.y = globalPosition.y
		instances[globalPosition].position.z = globalPosition.z
		instances[globalPosition].visible = false
		
	startingPosition = to_global(fireGrid.pick_random())
	fireGrid = gridThrowaway
	fireGrid[startingPosition]["flame"].setIntensity(1)
	fireGrid[startingPosition]["state"] = fireState.BURNING;
	instances[startingPosition].visible = true
	#print(startingPosition, " vs ", to_global(startingPosition))
	
	##finding & assigning neighbors
	for location in fireGrid.keys():
		for potentialNeighbor in fireGrid.keys():
			if location == potentialNeighbor: continue
			#print(location.distance_to(potentialNeighbor))
			if location.distance_to(potentialNeighbor) <= fireDistance:
				fireGrid[location]["neighbors"].append(potentialNeighbor)
	player = get_node("../Player3d")
	
	playerWaterController = get_node("../Player3d/Head/WaterController")
	playerWaterController.water.connect(_on_water)
	print(fireGrid)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceFireUpdate+= delta
	
	if (timeSinceFireUpdate >= fireSpreadTimer):
		
		for location in fireGrid:
			
			var fire = fireGrid[location]["flame"]
			setOnFire(fire, location)
			#instances[location].visible = true
		
		#for location in fireGrid:
			
		timeSinceFireUpdate = 0
		#print("____")
		#debugPrintFires()
		

func setOnFire(flame, location):
	if flame.getIntensity() < spreadIntensity:
		flame.intensifyFlame() 
		return
	instances[location].visible = true
	for neighbor in fireGrid[location]["neighbors"]:
		if fireGrid.has(neighbor):
			print("NEIGHBOR FOUND @, ", location)
			#instances[neighbor].visible = true
			if randi_range(1,8) == 8 and fireGrid[neighbor]["flame"].getIntensity() == 0:
				fireGrid[neighbor]["flame"].setIntensity(1)
				#print("Igniting ", neighbor)
				instances[location].visible = true
				
				#var instance = fireScene.instantiate()
				#add_child(instance)
				#instance.position.x = location.x
				#instance.position.y = location.y
				#instance.position.z = location.z
	
	
	flame.intensifyFlame()

# Something I was testing	
func trySpread(neighborLocs):
	for location in neighborLocs:
		if randi_range(1,8) == 8 and fireGrid[location]["state"] == fireState.NONE:
			#print("Igniting ", location)
			fireGrid[location]["flame"].setIntensity(1)
			fireGrid[location]["state"] = fireState.BURNING;
			instances[location].visible = true
	
#NOTE: for the water thingy, you can call this function to get the location, 
#assing it to a var then do fireGrid[var]["flame"].reduceFlame() or .setIntensity(0)
func findFireFromLocation(location: Vector3):
	const distanceGap = 5
	var closest = Vector3.INF
	var closestInDist = location.distance_to(closest)
	
	for fireLocation in fireGrid:
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
		fireGrid[closestFire]["flame"].setIntensity(0);
		instances[closestFire].visible = false
		#print("CLOSTEST FIRE: ", closestFire)

#NOT YET IMPLIMENTED, CAN DO LATER
	# on receive signal of splashing water on CELL, call reduceFlame() on CELL
	# update partsOnFire and fireGrid accordingly
	

func debugPrintFires():
	for location in fireGrid.keys():
		if fireGrid[location]["flame"].getIntensity() >= 3:
			print(location, ": ", fireGrid[location]["flame"])
			#", ", fireGrid[location]["neighbors"])
