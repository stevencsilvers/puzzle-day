extends CharacterBody2D
class_name Oscar

# Movement variables
@export var gravity : float = 400
@export var terminal_velocity : float = 300
@export var friction : float = 500
@export var acceleration : float = 1500
@export var push_force : float = 100
@export var bounce_force : float = -80

# Child references
@onready var area = $Area
@onready var raycast = $RayCast2D
@onready var sprite = $AnimatedSprite2D
@onready var animation_timer = $AnimationTimer
var sprite_open : bool = false
@onready var push_effect = $Push

# Keeps track of if duck/student are touching and from which side
var body_directions = []
var total_dir : int = 0

var push_sound_count : int = 9


func _process(_delta : float) -> void:
	body_directions.clear()
	# Gets all overlapping players
	for body in area.get_overlapping_bodies():
		if body is CharacterBody2D and body.velocity.x != 0 and body.can_move:
			# Calculates the direction players are pushing from
			var dir = -(body.position.x - position.x) / abs(body.position.x - position.x)
			# If player is pushing into block, then add their direction to array
			if sign(body.velocity.x) == sign(dir):
				body_directions.append(dir)
	
	
	if raycast.get_collider() != null and (raycast.get_collider() is Duck or raycast.get_collider() is Student) and raycast.get_collider().can_move: 
		velocity.y = bounce_force
	
	# Play push effect when moving
	push_effect.set_emitting(velocity.x != 0)


func _physics_process(delta : float) -> void:
	# Make oscar fall from gravity
	apply_gravity(delta)
	
	# Apply block pushing and friction
	apply_impulses(delta)
	
	move_and_slide()


func apply_impulses(delta : float) -> void:
	# If there are touching players stored in array
	if len(body_directions) > 0:
		for dir in body_directions:
			# Accelerate velocity towards move direction
			velocity.x = move_toward(velocity.x, dir * push_force, 900 * delta)
		
		# Trigger open animation
		trigger_animation(true)
		
		push_sound_count += 1
		if push_sound_count % 10 == 0:
			AudioManager.play("PushOscar")
	else: # No touching players: add friction to stop block
		velocity.x = move_toward(velocity.x, 0, 500 * delta)
		
		# Start timer to make animation show closed trash can
		trigger_animation(false)


func apply_gravity(delta : float) -> void:
	velocity.y += gravity * delta
	# Cap y velocity at terminal velocity
	velocity.y = min(velocity.y, terminal_velocity)


# Set oscar sprite to be open or closed
func trigger_animation(open : bool) -> void:
	if open:
		if !sprite_open:
			sprite.play("open")
			sprite_open = true
		animation_timer.stop()
	else:
		if sprite_open and animation_timer.is_stopped():
			animation_timer.start()


# When the player hasn't touched oscar for certain amount of time, play close animation
func _on_animation_timer_timeout() -> void:
	sprite.play("close")
	sprite_open = false
	push_sound_count = 9


# Oscar dies (from being crushed)
func poof() -> void:
	$Poof.play()
	AudioManager.play("Poof")
	queue_free()
