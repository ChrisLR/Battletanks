extends Area2D

var direction = Global.Direction.North
var hasHit = false

var speed = 5
var shooter = null



# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame = direction
	connect("body_entered", self, "_on_hit")
	connect("area_entered", self, "_on_hit")


func _physics_process(delta):
	if hasHit:
		return
	
	var motion = Global.DirectionVector[direction] * speed
	position += motion
		

func _on_hit(body):
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
