extends GridMap


var FireInstance = preload("res://Fire/FireInstance.gd")
	
	# Called when the node enters the scene tree for the first time.
var pheonixFire = FireInstance.fireInstance
var startingPosition = Vector3(0, 0, 0)
var fireOrigin = pheonixFire.new(startingPosition)
const fireDistance = 1
var timeSinceFireUpdate = 0
const fireSpreadTimer = 1.5
const spreadIntensity = 3
	
var partsOnFire
	
func _ready():
	print("!!!!")
	partsOnFire = {startingPosition: fireOrigin}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceFireUpdate+= delta
		
	if (timeSinceFireUpdate >= fireSpreadTimer):
		for fire in partsOnFire.values():
			setOnFire(fire)
			
		print(partsOnFire)
		timeSinceFireUpdate = 0
		
		

func setOnFire(flame):
		
	if flame.getIntensity() < spreadIntensity:
		flame.intensifyFlame()
		return
		
	var originX = flame.getPosition()[0]
	var originZ = flame.getPosition()[2]
		
	var newXP = fireDistance + originX
	var newXM= fireDistance - originX
		
	var newZP = fireDistance + originZ
	var newZM = fireDistance - originZ
		
	if not partsOnFire.has(Vector3(newXP, 0, originZ)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(newXP, 0, originZ)] = pheonixFire.new(Vector3(newXP, 0, originZ))

	if not partsOnFire.has(Vector3(newXP, 0, originZ)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(-newXP, 0, originZ)] = pheonixFire.new(Vector3(newXP, 0, originZ))
			
	if not partsOnFire.has(Vector3(originX, 0, newZP)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(originX, 0, newZP)] = pheonixFire.new(Vector3(originX, 0, newZP))
			
	if not partsOnFire.has(Vector3(originX, 0, newZP)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(originX, 0, newZP)] = pheonixFire.new(Vector3(originX, 0, newZP))
			
		
		
	if not partsOnFire.has(Vector3(newXP, 0, newZP)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(newXP, 0, newZP)] = pheonixFire.new(Vector3(newXP, 0, newZP))
		
	if not partsOnFire.has(Vector3(newXM, 0, newZM)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(newXM, 0, newZP)] = pheonixFire.new(Vector3(newXM, 0, newZM))
			
	if not partsOnFire.has(Vector3(newXP, 0, newZM)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(newXP, 0, newZM)] = pheonixFire.new(Vector3(newXP, 0, newZM))
			
	if not partsOnFire.has(Vector3(newXM, 0, newZP)): 
		if randi_range(1,8) == 8:
			partsOnFire[Vector3(newXM, 0, newZP)] = pheonixFire.new(Vector3(newXM, 0, newZP))
	
	
	flame.intensifyFlame()
	
	
	
	
	
	
var BEGIN_OF_COMMENTS
#refactor plan!
#partsOnFire & fireGrid. 
	#fireGrid = {coordinate: pheonixFire}. printing pheonixFire gives intensity. (ex, {(12,0,5): 1}
	#partsOnFire = fireGrid for intensity >= 3
#no fire = intensity 0. no deleting objects
#map all cells from get_used_cells() to fireGrid on _ready

#on each 

#setOnFire() refactor
	# for each cell in partsOnFire, find nearby cells in fireGrid within fireDistance for CELL
		# if already on fire, ignore
		# if not on fire, 1/8 chance for new fire to start (set intensity to 1 if so) via setIntensity(1)

#process() refactor
	#replace partsOnFire with fireGrid, pass CELL
	#for each on fire in fireGrid, intensifyFlame()
	#after doing the spread, re-filter partsOnFire with fireGrid intensity >= 3


#NOT YET IMPLIMENTED, CAN DO LATER
	# on receive signal of splashing water on CELL, call reduceFlame() on CELL
	# update partsOnFire and fireGrid accordingly
	
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_SPACE:
				print("Space key pressed!")

