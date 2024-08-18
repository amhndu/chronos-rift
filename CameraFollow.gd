extends Camera3D

@export_node_path("Node3D") var cameraPivotPath
@export_node_path("Node3D") var objectToFollowPath

@onready var cameraPivot = get_node(cameraPivotPath)
@onready var objectToFollow = get_node(objectToFollowPath)

@export var camAccel = 2 # Speed With Which The Camera Follows Up The Player (Not Need When Not using the `linear_interpolate` function
@export var camZoomAccel = 2 # Speed With Which The Camera Zooms (Not needed when not using lerp)
@export var camMinZoomSize = 10
@export var camMaxZoomSize = 40
@export var shouldUseLerp = true

@onready var camera: Camera3D = get_parent().get_node("Camera")
@onready var camTargetZoomSize = camera.size

func _process(delta):
	if objectToFollow == null:
		return

	# TODO Not working with Input Map
	#if Input.is_action_pressed("zoom_in"):
		#camTargetZoomSize = max(camTargetZoomSize - 1, camMinZoomSize)
	#elif Input.is_action_pressed("zoom_out"):
		#camTargetZoomSize = min(camTargetZoomSize + 1, camMaxZoomSize)

	if shouldUseLerp:
		cameraPivot.global_position = cameraPivot.global_position.lerp(objectToFollow.global_position, delta * camAccel)
		camera.size = lerp(float(camera.size), float(camTargetZoomSize), delta * camZoomAccel)
	else:
		cameraPivot.global_position = objectToFollow.global_position
		camera.size = camTargetZoomSize

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camTargetZoomSize = max(camTargetZoomSize - 1, camMinZoomSize)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camTargetZoomSize = min(camTargetZoomSize + 1, camMaxZoomSize)
