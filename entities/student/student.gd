extends CharacterBody2D
class_name Student


# Student movement variables
@export var jump_force : float = -150
@export var jump_release_force : float = -50
@export var max_speed : float = 80
@export var acceleration : float = 800
@export var friction : float = 900
@export var gravity : float = 400
@export var fall_gravity : float = 800
@export var terminal_velocity : float = 300

var jumping : bool = false
var can_move : bool = true
var input = Vector2.ZERO
var has_cupcake : bool = false

# Attaching a button currently
var pointing : bool = false

# Child References
@onready var sprite := $Sprite2D
@onready var element_detector := $ElementDetector
@onready var particles = $StudentParticles


func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	
	# Get input from WASD/arrow keys and store in a vector
	input.x = Input.get_action_strength("student_right") - Input.get_action_strength("student_left")
	
	if input.x == 0: # Apply friction if player isn't moving
		apply_friction(delta)
	elif can_move:
		apply_acceleration(input.x, delta)
	
	# Allow player to jump if they are grounded
	if is_on_floor():
		jumping = false
		
		if can_move and Input.is_action_just_pressed("student_jump"):
			jumping = true
			velocity.y = jump_force
			particles.jump_effect()
			AudioManager.play("Jump")
	else:
		if can_move and jumping and Input.is_action_just_released("student_jump") and velocity.y < jump_release_force:
			# Cut velocity if jump button is released early to make more responsive jump
			velocity.y = jump_release_force
	
	
	move_and_slide()


func apply_gravity(delta : float) -> void:
	# Apply higher gravity when player is falling than jumping
	if velocity.y < 0:
		velocity.y += gravity * delta
	else:
		velocity.y += fall_gravity * delta
	
	# Cap y velocity at terminal velocity
	velocity.y = min(velocity.y, terminal_velocity)


func apply_friction(delta : float) -> void:
	# Make player's x velocity go towards 0
	velocity.x = move_toward(velocity.x, 0, friction * delta)


func apply_acceleration(amount : float, delta : float) -> void:
	# Make player's x velocity go towards the max speed in the direction of x input
	velocity.x = move_toward(velocity.x, max_speed * amount, acceleration * delta)


# When player collects cupcake
func collect_cupcake() -> void:
	has_cupcake = true
	can_move = false
	
	# Stop from colliding with Oscar
	# Stop from colliding with Oscar
	for node in get_tree().get_nodes_in_group("oscar"):
		node.set_collision_mask_value(2, false)
	set_collision_mask_value(9, false)
	
	particles.confetti_effect()


# Player dies (from being crushed)
func poof() -> void:
	# Poof particle effect
	particles.poof_effect()
	# Poof sound effect
	AudioManager.play("Poof")
	
	# Remove student from scene tree
	queue_free()
