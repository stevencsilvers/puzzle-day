extends CharacterBody2D
class_name Duck


# Duck movement variables
@export var max_speed : float = 70
@export var smoothing_distance : float = 30
var can_move : bool = true

# Child References
@onready var sprite := $Sprite2D
@onready var cursor := $Cursor/CursorSprite
@onready var element_detector = $ElementDetector

# Attaching a button currently
var pointing : bool = false


func _ready() -> void:
	# Make it so player can't move for half a second
	can_move = false
	await get_tree().create_timer(0.5).timeout
	can_move = true


func _process(_delta : float) -> void:
	# Flip sprite based on direction of movement
	if can_move:
		sprite.flip_h = velocity.x > 0
	
	# Make cursor sprite follow mouse
	cursor.position = get_global_mouse_position()


func _physics_process(_delta : float) -> void:
	# Set duck velocity to max speed in the direction of player. Slow down speed as duck gets close to mouse
	velocity = (get_global_mouse_position() - position).normalized() * max_speed * (min(smoothing_distance, get_global_mouse_position().distance_to(position))) / smoothing_distance
	
	if can_move:
		move_and_slide()


# When player collects cupcake
func collect_cupcake():
	# Stop player movement
	can_move = false
	
	# Cupcake collected animation
	sprite.play("cupcake")
	
	# Stop from colliding with Oscar
	for node in get_tree().get_nodes_in_group("oscar"):
		node.set_collision_mask_value(3, false)
	set_collision_mask_value(9, false)
	
	# Confetti particle effect
	$Confetti.play()


func _unhandled_input(event) -> void:
	# Play rubberduck sound when trackpad is clicked
	if event.is_action_pressed("duck_action"):
		AudioManager.play("Rubberduck")


# Player dies (from being crushed)
func poof() -> void:
	# Poof particle effect
	$Poof.play()
	# Poof SFX
	AudioManager.play("Poof")
	
	# Remove duck from scene tree
	queue_free()
