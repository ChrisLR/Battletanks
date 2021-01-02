extends Reference

var Direction = Global.Direction

var host = null
var lastDirection = null
var lastPosition = Vector2.ZERO
var timeUntilDirectionChange = 0
var possibleDirections = [Direction.North, Direction.East, Direction.South, Direction.West]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not host or host.dead:
		return
	
	if lastPosition and host.position:
		var moveDelta = lastPosition.distance_to(host.position)
		if abs(moveDelta) < 0.5:
			timeUntilDirectionChange -= 1
	
	if lastDirection != null and timeUntilDirectionChange <= 0:
		timeUntilDirectionChange = 5
		host._move(lastDirection)
	else:
		timeUntilDirectionChange -= delta
		
	var newDirection = lastDirection
	while newDirection == lastDirection:
		newDirection = possibleDirections[randi() % possibleDirections.size()]
	
	lastDirection = newDirection
	lastPosition = host.position
	
	
	if host.shootDelay <= 0:
		host.shoot()
	
