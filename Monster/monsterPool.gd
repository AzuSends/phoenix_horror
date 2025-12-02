extends Node3D

var Monster = preload("res://Monster/Monster.tscn")
const maxMonsters = 5
var monsterPool = []
var monsterPoolData = {}
const maxX = 47.793
const minX = 12.793

const maxZ = 56.179
const minZ = 6.179

const respawnTimer = 15


func setupMonsterPool():
	for i in 5:
		var newMonster = Monster.instantiate()
		var randX = randf_range(minX, maxX)
		var randZ = randf_range(minZ, maxZ)
		newMonster.position = Vector3(randX, 2.5, randZ)
		newMonster.name = "Monster"
		print(newMonster.name)
		get_tree().current_scene.add_child(newMonster)
		monsterPool.push_back(newMonster)
		monsterPoolData[i] = {"isAlive": true, "timeDead": 0}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if monsterPool.is_empty():
		setupMonsterPool()
		return
		
	for i in monsterPool.size():
		var isMonsterAlive = monsterPool[i].process_mode == Node.PROCESS_MODE_INHERIT
		
		if monsterPoolData[i].isAlive != isMonsterAlive:
			monsterPoolData[i].isAlive = isMonsterAlive
		
		if not isMonsterAlive:
			monsterPoolData[i].timeDead += delta
			
		if monsterPoolData[i].timeDead >= respawnTimer:
			monsterPoolData[i].isAlive = true
			monsterPoolData[i].timeDead = 0
			monsterPool[i].reviveDead()
