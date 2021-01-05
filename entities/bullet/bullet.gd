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
	if body == shooter:
		return
		
	if hasHit:
		return
		
	if body.has_method("on_hit"):
		body.on_hit()
	
	if body is TileMap:
		_destroy_blocks(body)
		
	$Sprite.visible = false
	$Hit.visible = true
	$AnimationPlayer.play("Hit")
	hasHit = true

func on_destroy():
	if shooter:
		shooter.shotBullet = null
	queue_free()

func _destroy_blocks(tile_map):
	var rect = Rect2(position, $CollisionShape2D.shape.extents)
	for x in range(rect.position.x - 8, rect.end.x + 4, 4):
		for y in range(rect.position.y - 8, rect.end.y + 4, 4):
			var tilePos = tile_map.world_to_map(Vector2(x, y))
			var tileNo = tile_map.get_cellv(tilePos)
			if tileNo == -1:
				continue
				
			var tile_set = tile_map.tile_set
			var tileName = tile_set.tile_get_name(tileNo)
			if tileName == 'WallBrick':
				tile_map.set_cellv(tilePos, -1)
