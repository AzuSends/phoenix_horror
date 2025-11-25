class fireInstance extends Node3D:
	# Called when the node enters the scene tree for the first time.
	var isOnFire: bool
	var intensity: int
	const maxLevelFlame = 5
	const minLevelFlame = 1
	
	
	func _init(firePosition: Vector3):
		isOnFire = false;
		position = firePosition
		intensity = 0


	# Called every frame. 'delta' is the elapsed time since the previous frame.
	func _process(_delta):
		pass
		
		
		#Changed name for clarity
	func tryIntensifyFlame():
		if intensity != maxLevelFlame && intensity >= 1:
			intensity += 1
		else:
			#print("ERR: flame @" + str(selfPosition) + "can not exceed lvl 5")
			pass
		updateState()
	
	func reduceFlame():
		if intensity != minLevelFlame:
			intensity -= 1
		elif intensity == minLevelFlame:
			intensity = 0
		updateState()
	
	func setIntensity(val):
		if val >= 0 and val <= 5:
			intensity = val
		updateState()
			
	func getPosition():
		return position
		
	func getIntensity():
		return intensity
	func getFireState():
		return isOnFire
		
	func _to_string():
		return str(intensity)
	
	func updateState():
		if intensity > 0:
			isOnFire = true;
		elif intensity <= 0:
			isOnFire = false;
		
	
