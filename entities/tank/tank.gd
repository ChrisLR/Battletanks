extends KinematicBody2D

var ActionButtonEnum = load("res://scripts/ActionButtonEnum.gd").ActionButtonEnum

var Direction = Global.Direction
var BulletClass = preload("res://entities/bullet/bullet.tscn")

# PRELOAD SOUNDS
var SoundEnemyTankExplosion = preload("res://assets/sounds/enemytank_explode.wav")
var SoundPlayerTankExplosion = preload("res://assets/sounds/playertank_explode.wav")
var SoundFireBullet = preload("res://assets/sounds/bullet_fire.wav")

enum TankColor {
	Yellow = 0
	Green = 1
	Gray = 2
	Red = 3
}
enum TankType {
	Basic = 0    # Points 100, Health 1, Speed 1, Shot 1
	Fast = 1     # Points 200, Health 1, Speed 3, Shot 2
	Power = 2    # Points 300, Health 1, Speed 2, Shot 3
	Armor = 3    # Points 400, Health 4, Speed 2, Shot 2
}

const PointsMap = {
	TankType.Basic: 100,
	TankType.Fast: 200,
	TankType.Power: 300,
	TankType.Armor: 400,
}
const HealthMap = {
	TankType.Basic: 1,
	TankType.Fast: 1,
	TankType.Power: 1,
	TankType.Armor: 4,
}
const SpeedMap = {	  # Players are always at least speed 1
	TankType.Basic: 0.5,
	TankType.Fast: 1.5,
	TankType.Power: 1,
	TankType.Armor: 1,
}
const FireRate = {
	TankType.Basic: 5,
	TankType.Fast: 4,
	TankType.Power: 3,
	TankType.Armor: 4,
}

export var tank_color = TankColor.Yellow
export var tank_type = TankType.Basic
export var isPlayer = false
var controller = null

var animOffset = 0
var direction = Direction.North
var motion = Vector2()
var lastKeypresses = []

var TimesDamaged = 0
var shootDelay = 0
var shotBullet = null

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animOffset = get_anim_offset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if dead:
		return
	
	if not isPlayer and controller:
		controller._process(delta)
		
	var _collision = move_and_collide(motion)
	if shootDelay > 0:
		shootDelay -= delta
	

const initialColorOffset = {
	TankColor.Yellow: 0,
	TankColor.Gray: 8,
	TankColor.Green: 128,
	TankColor.Red: 136,
}

func get_anim_offset():
	var _colorOffset = initialColorOffset[tank_color]
	var _dirOffset = direction * 2
	var _tankTypeOffset = tank_type * 16
	var _playerOffset = 0
	if not isPlayer:
		_playerOffset = 64
		
	var new_offset = _colorOffset + _dirOffset + _playerOffset + _tankTypeOffset
	
	return new_offset
	

func update_frame(animFrame):
	$Sprite.frame = animOffset + animFrame
	

func _move(_direction):
	var _update_anim = false
	var _moveSpeed = SpeedMap[tank_type]
	if isPlayer and _moveSpeed < 1:
		_moveSpeed = 1
	
	if _direction != direction:
		_update_anim = true
	
	direction = _direction
	if _update_anim:
		animOffset = get_anim_offset()
		update_frame(0)
	
	motion = Global.DirectionVector[direction] * _moveSpeed
	$AnimationPlayer.play("Move")
	

func move_north():
	_move(Direction.North)

func move_south():
	_move(Direction.South)
	
func move_west():
	_move(Direction.West)

func move_east():
	_move(Direction.East)

func shoot():
	if shootDelay > 0 or shotBullet != null:
		return
	
	var newBullet = BulletClass.instance()
	newBullet.direction = direction
	newBullet.shooter = self
	shotBullet = newBullet
	
	get_parent().add_child(newBullet)
	newBullet.position = position + Global.DirectionVector[direction] * 4
	if isPlayer:
		shootDelay = 1
	else:
		shootDelay = FireRate[tank_type]
	
	$AudioStreamPlayer.stream = SoundFireBullet
	$AudioStreamPlayer.play()
	

func idle():
	$AnimationPlayer.play("idle")
	motion = Vector2.ZERO


func handle_key_pressed(key_presses):
	if dead:
		return
		
	if ActionButtonEnum.Up in key_presses:
		move_north()
	elif ActionButtonEnum.Right in key_presses:
		move_east()
	elif ActionButtonEnum.Left in key_presses:
		move_west()
	elif ActionButtonEnum.Down in key_presses:
		move_south()
	else:
		idle()
	
	if ActionButtonEnum.A in key_presses and not ActionButtonEnum.A in lastKeypresses:
		shoot()

func on_hit():
	TimesDamaged += 1
	if TimesDamaged >= HealthMap[tank_type]:
		on_death()

func on_death():
	dead = true
	$CollisionShape2D.set_deferred('disabled', true)
	$Sprite.visible = false
	$AnimationPlayer.play("Death")
	if isPlayer:
		$AudioStreamPlayer.stream = SoundPlayerTankExplosion
	else:
		$AudioStreamPlayer.stream = SoundEnemyTankExplosion
	$AudioStreamPlayer.play()

func on_death_anim_end():
	if not isPlayer:
		queue_free()
	else:
		# Must respawn, will reuse same object
		pass
