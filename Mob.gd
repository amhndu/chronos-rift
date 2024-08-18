extends Node3D

@export var time_scale: float = 1

var attack_mode: Node3D = null
var moving = false

var max_rotation_speed = PI / 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Body/Pivot/Character/AnimationPlayer.play("CharacterArmature|Idle")
	$Body/Pivot/Character/AnimationPlayer.seek(randf_range(0, 2))

	
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


func _physics_process(delta: float) -> void:
	if attack_mode != null:
		var target = transform.looking_at(attack_mode.position, Vector3(0, 1, 0), true)
		if target.basis.z.dot(transform.basis.z) < 0.99:
			$Body/Pivot/Character/AnimationPlayer.play("CharacterArmature|Walk")
		else:
			$Body/Pivot/Character/AnimationPlayer.play("CharacterArmature|Attack")
		transform = transform.interpolate_with(target, delta * max_rotation_speed)
	else:
		$Body/Pivot/Character/AnimationPlayer.play("CharacterArmature|Idle")
		

func _on_proximity_collider_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		attack_mode = body


func _on_proximity_collider_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		attack_mode = null


func _on_domain_body_entered(body: Node3D) -> void:
	if body.has_method("scale_time"):
		body.scale_time(time_scale)


func _on_domain_body_exited(body: Node3D) -> void:
	if body.has_method("scale_time"):
		body.scale_time(1 / time_scale)
