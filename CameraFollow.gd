extends Camera3D

@export_node_path("Node3D") var cameraPivotPath
@export_node_path("Node3D") var objectToFollowPath

@onready var cameraPivot = get_node(cameraPivotPath)
@onready var objectToFollow = get_node(objectToFollowPath)

@export var camAccel = 2 # Speed With Which The Camera Follows Up The Player (Not Need When Not using the `linear_interpolate` function

func _process(delta):
	if objectToFollow == null:
		return
	cameraPivot.global_position = cameraPivot.global_position.lerp(objectToFollow.global_position, delta * camAccel)
	#cameraPivot.global_position = objectToFollow.global_position # Un-Comment This & Comment Above if you want camera to just follow the player without any smooth follow-up
