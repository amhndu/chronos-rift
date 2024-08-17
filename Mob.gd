extends Node3D

@export var time_scale: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if time_scale == 1:
		# no domain object
		$Domain.hide()
		#$Domain.monitorable = false
	elif time_scale > 1:
		# TODO: avoid copying mesh per object
		$Domain/MeshInstance3D.mesh = $Domain/MeshInstance3D.mesh.duplicate()
		$Domain/MeshInstance3D.mesh.material = $Domain/MeshInstance3D.mesh.material.duplicate()
		$Domain/MeshInstance3D.mesh.material.albedo_color = Color(Color.RED, 0.3)
	else:
		$Domain/MeshInstance3D.mesh = $Domain/MeshInstance3D.mesh.duplicate()
		$Domain/MeshInstance3D.mesh.material = $Domain/MeshInstance3D.mesh.material.duplicate()
		$Domain/MeshInstance3D.mesh.material.albedo_color = Color(Color.BLUE, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
