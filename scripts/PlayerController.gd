extends Reference

var ActionButtonEnum = load("res://scripts/ActionButtonEnum.gd").ActionButtonEnum

var host = null
var playerId = null
var usesJoy: bool = false
var joyId: int = 0
var controlType: String = ""
var alreadySet:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if host == null:
		return
	
	if playerId == null:
		return
	
	if alreadySet == false:
		controlType = Global.PlayerControls[playerId - 1]
		if not controlType == "K1" and not controlType == "K2":
			usesJoy = true
			joyId = int(controlType)
		alreadySet = true
		
	var keys = []
	if usesJoy == false:
		# KEYBOARD CODE
		if Input.is_action_pressed(controlType + "_Down"):
			keys.append(ActionButtonEnum.Down)
		elif Input.is_action_pressed(controlType + "_Up"):
			keys.append(ActionButtonEnum.Up)
			
		if Input.is_action_pressed(controlType + "_Left"):
			keys.append(ActionButtonEnum.Left)
		elif Input.is_action_pressed(controlType + "_Right"):
			keys.append(ActionButtonEnum.Right)
		
		if Input.is_action_pressed(controlType + "_A"):
			keys.append(ActionButtonEnum.A)
		
		if Input.is_action_pressed(controlType + "_B"):
			keys.append(ActionButtonEnum.B)
		
		if Input.is_action_pressed(controlType + "_C"):
			keys.append(ActionButtonEnum.C)
		
		if Input.is_action_pressed(controlType + "_Start"):
			keys.append(ActionButtonEnum.Start)
	else:
		# CONTROLLER CODE
		var horizontal_axis:float = Input.get_joy_axis(joyId, 0)
		var vertical_axis:float = Input.get_joy_axis(joyId, 1)

		if Input.is_joy_button_pressed(joyId, JOY_DPAD_DOWN) or vertical_axis > 0.5:
			keys.append(ActionButtonEnum.Down)
		elif Input.is_joy_button_pressed(joyId, JOY_DPAD_UP) or vertical_axis < -0.5:
			keys.append(ActionButtonEnum.Up)
			
		if Input.is_joy_button_pressed(joyId, JOY_DPAD_LEFT) or horizontal_axis < -0.5:
			keys.append(ActionButtonEnum.Left)
		elif Input.is_joy_button_pressed(joyId, JOY_DPAD_RIGHT) or horizontal_axis > 0.5:
			keys.append(ActionButtonEnum.Right)
		
		if Input.is_joy_button_pressed(joyId, JOY_XBOX_X):
			keys.append(ActionButtonEnum.A)
		
		if Input.is_joy_button_pressed(joyId, JOY_XBOX_A):
			keys.append(ActionButtonEnum.B)
		
		if Input.is_joy_button_pressed(joyId, JOY_XBOX_B):
			keys.append(ActionButtonEnum.C)
		
		if Input.is_joy_button_pressed(joyId, JOY_START):
			keys.append(ActionButtonEnum.Start)
		
	host.handle_key_pressed(keys)
