extends Node2D

var PlayerController = load("res://scripts/PlayerController.gd")

var controllers = []

var delayUntilSpawn = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	var P1C = PlayerController.new()
	P1C.host = $P1
	P1C.controlType = "K1"
	P1C.playerId = 1
	
	var P2C = PlayerController.new()
	P2C.host = $P2
	P2C.controlType = "K2"
	P2C.playerId = 2
	
	controllers = [P1C, P2C]

func _process(delta):
	if delayUntilSpawn <= 0:
		$EnemySpawner.spawn(2, 0)
		delayUntilSpawn = 5
	else:
		delayUntilSpawn -= delta
		
	for controller in controllers:
		controller._process(delta)
