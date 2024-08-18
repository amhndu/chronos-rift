extends Node3D

@export var time_scale: float = 1

var attack_mode: Node3D = null
var moving = false

var max_rotation_speed = PI / 2

@onready var animation_player = $Body/Pivot/Character/AnimationPlayer
@export var bodyBoneAttachment: BoneAttachment3D
@export var bodyCollider: CollisionShape3D

var is_alive = true
@onready var spawn_position = self.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func _physics_process(delta: float) -> void:
	if !is_alive:
		return

	# make the body collider follow the head from the model
	if bodyBoneAttachment and bodyCollider:
		bodyCollider.global_position = bodyBoneAttachment.global_position
	
	if attack_mode != null:
		var target = transform.looking_at(attack_mode.position, Vector3(0, 1, 0), true)
		if target.basis.z.dot(transform.basis.z) < 0.99:
			animation_player.play("CharacterArmature|Walk")
		else:
			animation_player.play("CharacterArmature|Attack")
		transform = transform.interpolate_with(target, delta * max_rotation_speed * time_scale)
	else:
		animation_player.play("CharacterArmature|Idle")
		

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

func die():
	if !is_alive:
		return
	is_alive = false
	animation_player.play("CharacterArmature|Death")
	await get_tree().create_timer(0.7).timeout
	#queue_free()
	self.visible = false
	#TODO Fix hacky way of disabling mob along with all colliders
	self.global_position = Vector3(9999, 9999, 9999)
	animation_player.stop()

func reset():
	animation_player.play("CharacterArmature|Idle")
	animation_player.seek(randf_range(0, 2))
	animation_player.speed_scale = time_scale

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
	self.global_position = spawn_position
	is_alive = true
	self.visible = true
