extends Node2D
class_name ButtonBlock

# Variables to keep track of which players are colliding with the Area2D
var duck_entered : bool = false
var student_entered : bool = false
var oscar_entered : bool = false

# If player is activating block
var active : bool = false

# Variable to keep track of what player the pointer should follow
var target_player = null
# If pointer is currently being made
var pointing_in_progress : bool = false
# Target level element (moving block)
@export var target_element : Node2D = null

# Child references
@onready var pointer_follow = $PointerFollow
@onready var pointer_follow_timer = $PointerFollow/Timer
var timer_counter : float = 0
@onready var pointer_target = $PointerTarget

@onready var sprite = $Sprite
@export var off_color : Color = Color(0.5,0.5,0.5)
@onready var on_color : Color = Color(1, 1, 1)

# If button is blinking
var blink_on : bool = true
# Pointer follow offset wobble
var wobble := Vector2.ZERO


func _ready() -> void:
	# If target element was assigned in editor, make pointer
	if (target_element != null):
		pointer_target.set_shown(true)
	
	# Set outline shader to be unique
	sprite.material = sprite.material.duplicate()


func _unhandled_input(event) -> void:
	# If user presses action button and is creating pointer, then assign target element to
	# whatever element they're touching
	if pointing_in_progress and target_player.element_detector.touching_element != null and ((event.is_action_pressed("duck_action") and target_player is Duck) or (event.is_action_pressed("student_action") and target_player is Student)):
		assign_target_element(target_player.element_detector.touching_element)
		stop_pointing()
	
	# Begin assigning pointer to target element, only if a target element isn't already assigned
	if target_element == null:
		if !pointing_in_progress and duck_entered and event.is_action_pressed("duck_action"):
			print("DUCKDUCK")
			begin_pointing(get_tree().get_first_node_in_group("duck"))
		
		if !pointing_in_progress and student_entered and event.is_action_pressed("student_action"):
			print("STUDENT")
			begin_pointing(get_tree().get_first_node_in_group("student"))


# Make pointer Line2D begin following player
func begin_pointing(follow_target) -> void:
	pointing_in_progress = true
	target_player = follow_target
	
	if target_element != null:
		target_element.activate(false)
	
	# Reset any previous pointers
	target_element = null
	pointer_target.set_shown(false)
	
	# Begin pointer Line2D following player
	pointer_follow_timer.start()
	pointer_follow.set_visible(true)
	pointer_follow.clear_points()
	
	set_modulate(on_color)
	$BlinkTimer.start()
	
	# Assign pointing in progress variable in player scene
	target_player.pointing = true
	
	AudioManager.play("Point")


# Assign which level element button is connected to
func assign_target_element(element):
	target_element = element
	target_element.block.set_modulate(Color(0.8,0.8,0.8,1))
	target_element.add_connected_button(self)
	pointer_target.set_shown(true)


# Stop Line2D from following
func stop_pointing() -> void:
	# Assign pointing in progress variable in player scene
	target_player.pointing = false
	
	# Stop pointer from following
	pointing_in_progress = false
	target_player = null
	pointer_follow_timer.stop()
	pointer_follow.set_visible(false)
	
	# Stop button from blinking
	$BlinkTimer.stop()
	
	AudioManager.play("Point")


# Duck/student/oscar enters Area2D
func _on_area_body_entered(body: Node2D) -> void:
	if body is Duck:
		duck_entered = true
	if body is Student:
		student_entered = true
	if body is Oscar:
		oscar_entered = true
	
	# Play sound
	if target_element != null and !active:
		AudioManager.play("BlockMoveOn")
		AudioManager.play("ButtonOn")


# Duck/student/oscar leaves Area2D
func _on_area_body_exited(body: Node2D) -> void:
	if body is Duck:
		duck_entered = false
	if body is Student:
		student_entered = false
	if body is Oscar:
		oscar_entered = false
	
	# Play sound
	if target_element != null and !duck_entered and !student_entered and !oscar_entered:
		AudioManager.play("BlockMoveOff")
		AudioManager.play("ButtonOff")


# Make line follow target player
func _on_timer_timeout() -> void:
	if target_player != null:
		var new_points = pointer_follow.get_points()
		# Add some vertical oscilation to  pointer trail
		wobble = Vector2(0, sin(timer_counter) * 2)
		if target_player is Student: # If target player is student, offset line2d to follow from center of student
			wobble += Vector2(0, 9)
		new_points.append((target_player.position - position) + wobble)
		pointer_follow.set_points(new_points)
		
		# Increment timer to use for wobble based on velocity of player so that the wavelength stays
		# the same even when player slows down
		timer_counter = clamp(timer_counter + (0.001 * target_player.velocity.length()), 0, 2 * PI)
		if timer_counter >= 2 * PI:
			timer_counter = 0


func _process(_delta : float) -> void:
	active = (student_entered or duck_entered or oscar_entered) and target_element != null
	
	# Make target element activate
	if active and target_element != null:
		target_element.activate(true)
		set_appearance(true)
	elif target_element != null:
		target_element.activate(false)
		set_appearance(false)
	else:
		set_appearance(false)
	
	
	# Make outline show when either player goes over button and it's not already connected
	sprite.material.set_shader_parameter("show", (duck_entered or student_entered) and target_element == null and !pointing_in_progress)


# Set if button sprite is light up or not
func set_appearance(on : bool):
	if !pointing_in_progress:
		if on:
			sprite.play("pressed")
			set_modulate(on_color)
		else:
			sprite.play("default")
			set_modulate(off_color)


# Set modulate color for when button is off
func set_on_off_color(on_col : Color, off_col : Color):
	on_color = on_col
	off_color = off_col


# When timer reaches 0, alternate button from bright to dim
func _on_blink_timer_timeout() -> void:
	blink_on = !blink_on
	if blink_on:
		set_modulate(on_color)
	else:
		set_modulate(off_color)
