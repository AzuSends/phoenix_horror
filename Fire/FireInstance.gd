class fireInstance extends Node3D:
	# Called when the node enters the scene tree for the first time.
	var selfPosition
	var isOnFire: bool
	var intensity: int
	const maxLevelFlame = 5
	const minLevelFlame = 1
	
	
	func _init(position):
		selfPosition = position
		intensity = 0


	# Called every frame. 'delta' is the elapsed time since the previous frame.
	func _process(_delta):
		pass
		
		
		
	func intensifyFlame():
		if intensity != maxLevelFlame:
			intensity += 1
		else:
			#print("ERR: flame @" + str(selfPosition) + "can not exceed lvl 5")
			pass
	
	func reduceFlame():
		if intensity != minLevelFlame:
			intensity -= 1
	
	func setIntensity(val):
		if val >= 0 and val <= 5:
			intensity = val
			
	func getPosition():
		return selfPosition
		
	func getIntensity():
		return intensity
		
	func _to_string():
		return str(intensity)
		
		
	
