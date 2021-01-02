extends StaticBody2D


var dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_hit():
	dead = true
	$Sprite.frame = 1
