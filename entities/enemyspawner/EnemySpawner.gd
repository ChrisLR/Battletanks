extends Area2D


var colliding = false
var tankClass = preload("res://entities/tank/tank.tscn")
var tankAIClass = preload("res://scripts/AITankController.gd")



# Called when the node enters the scene tree for the first time.
func _ready():
	var _s = connect("body_entered", self, "on_body_entered")
	_s = connect("body_exited", self, "on_body_exited")

func spawn(tank_color, tank_type):
	if colliding:
		return
	
	var tank = tankClass.instance()
	tank.position = self.position
	tank.tank_color = tank_color
	tank.tank_type = tank_type
	
	var tankAI = tankAIClass.new()
	tankAI.host = tank
	tank.controller = tankAI
	
	get_parent().add_child(tank)
	tank.update_frame(0)

func on_body_entered(_body):
	colliding = true
	
func on_body_exited(_body):
	colliding = false
