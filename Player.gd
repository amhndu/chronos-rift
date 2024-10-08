extends CharacterBody3D
class_name Player

signal player_hit
signal mob_kill

var time_scaling_factor = 1.0
## How fast the player moves in meters per second.
@export var speed = 10
## Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20
## Vertical impulse applied to the character upon bouncing over a mob in meters per second.
@export var bounce_impulse = 16
## The downward acceleration when in the air, in meters per second.
@export var fall_acceleration = 75

var animation_player: AnimationPlayer
var is_alive = true
var is_attacking = false # prevent attack button spamming
var can_attack = true 
var mob_kill_cooldown = 1 # attack cooldown in number of seconds after mob kill
var spawn_location = Vector3.ZERO
var attack_speed = 1.5

func _ready():
	animation_player = $Pivot/player_astronaut_imported/AnimationPlayer
	$"Pivot/player_astronaut_imported/RootNode/CharacterArmature/Skeleton3D/BoneAttachment3D/WeaponPivot/Area3D".body_entered.connect(_on_weapon_body_entered)

# NOTE: For time scaling to work, all acceleration (or velocity increments) must be defined properties
# Any new property must be added to `scale_time` method
func _physics_process(delta):
	if !is_alive:
		return

	if Input.is_action_pressed("attack") && can_attack && !is_attacking:
		is_attacking = true
		animation_player.play("CharacterArmature|Sword_Slash", 0.2, attack_speed)
		var anim_time = animation_player.current_animation_length / animation_player.get_playing_speed()
		var timeoutSignal:Signal = get_tree().create_timer(anim_time).timeout
		timeoutSignal.connect(on_timeout_attack)
		return

	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		# In the lines below, we turn the character when moving and make the animation play faster.
		direction = direction.normalized().rotated(Vector3(0, 1, 0), deg_to_rad(-45))
		# Setting the basis property will affect the rotation of the node.
		basis = Basis.looking_at(direction)
		if !is_attacking:
			# Switch to correct animation
			animation_player.play("CharacterArmature|Walk", 0.2)
		else:
			# Slower movement while attacking
			direction *= 0.3
		# TODO Scale animation speed according to scale and time_scale
		#animation_player.speed_scale = time_scaling_factor
	elif !is_attacking:
		animation_player.play("CharacterArmature|Idle_Sword", 0.2)
		

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
		if !is_attacking:
			animation_player.play("CharacterArmature|Idle_Sword", 0.2)

	# 
	# We apply gravity every frame so the character always collides with the ground when moving.
	# This is necessary for the is_on_floor() function to work as a body can always detect
	# the floor, walls, etc. when a collision happens the same frame.
	velocity.y -= fall_acceleration * delta
	move_and_slide()

	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if collider.is_in_group("mob") && collider.owner.is_alive:
			die()

func on_timeout_attack():
	is_attacking = false

func die():
	if !is_alive:
		return
	is_alive = false
	animation_player.play("CharacterArmature|Death")
	await get_tree().create_timer(1.5).timeout
	#queue_free()
	player_hit.emit()
	self.visible = false

func reset_player():
	self.global_position = spawn_location
	animation_player.play("CharacterArmature|Idle_Sword")
	is_attacking = false
	time_scaling_factor = 1
	is_alive = true
	can_attack = true
	self.visible = true

func scale_time(scale: float):
	print("time scaling by: ", scale, " finalScale: ", time_scaling_factor * scale)
	speed *= scale
	jump_impulse *= scale
	bounce_impulse *= scale
	fall_acceleration *= scale
	time_scaling_factor *= scale

func _on_weapon_body_entered(body: Node3D) -> void:
	if not is_alive or not is_attacking or not can_attack:
		return
		
	if body.is_in_group("mob") and body.owner.is_alive:
		can_attack = false
		body.owner.die()
		mob_kill.emit()
		await get_tree().create_timer(mob_kill_cooldown).timeout
		can_attack = true
