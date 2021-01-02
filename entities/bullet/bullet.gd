extends Area2D

var direction = Global.Direction.North
var hasHit = false

var speed = 3
var shooter = null



# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame = direction
	var _s = connect("body_entered", self, "_on_hit")
	_s = connect("area_entered", self, "_on_hit")


func _physics_process(_delta):
	if hasHit:
		return
	
	var motion = Global.DirectionVector[direction] * speed
	position += motion
		

func _on_hit(body):
	if hasHit:
		return
		
	if body.has_method("on_hit"):
			body.on_hit()
		
	$Sprite.visible = false
	$Hit.visible = true
	$AnimationPlayer.play("Hit")
	hasHit = true

func on_destroy():
	if shooter:
		shooter.shotBullet = null
	queue_free()
