extends Area2D


var colliding = false
var tankClass = preload("res://entities/tank/tank.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func spawn(tank_color, tank_type):
	if colliding:
		return
	
	var tank = tankClass.instance()
	tank.position = self.position
	tank.tank_color = tank_color
	tank.tank_type = tank_type
	get_parent().add_child(tank)
	tank.update_frame(0)

func on_body_entered(body):
	colliding = true
	
func on_body_exited(body):
	colliding = false
