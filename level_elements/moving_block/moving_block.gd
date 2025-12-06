@tool
extends Node2D

@export var path_line : Line2D
@onready var block := $Block
# Where block should end up when fully moved
@export var final_position : Vector2 = Vector2(0, -64)

# Float that keeps track of blocks movement from initial to final position range [0, 1]
var move_progress : float = 0
# Int that keeps track of if the block is moving forward, backward, or none
var move_direction : int = -1
@export var move_speed : float = 10

var last_position := Vector2.ZERO

# Handle multiple if blocks connected to moving block
var active_requests : int = 0

# Keeps track of buttons that are connected to this moving block (plus their colors)
var buttons : Array[ButtonBlock] = []
var buttons_on_colors : Array[Color] = []
var buttons_on_active_colors : Array[Color] = [] # Colors of buttons connected and active
var buttons_off_colors : Array[Color] = []
var target_color : Color = Color(1,1,1,1)
@export var color_change_speed : float = 0.1


func _ready() -> void:
	path_line.set_point_position(1, final_position)
	block.set_modulate(Color(0.8,0.8,0.8,1))


func _process(_delta: float) -> void:
	# Show path of moving block in editor to make level editing easier
	if Engine.is_editor_hint():
		path_line.set_point_position(1, final_position)
	
	if !Engine.is_editor_hint():
		
		# If 1+ if blocks are activating, then move
		if active_requests > 0:
			move_direction = 1
		else:
			move_direction = -1
		
		# Reset active requests every frame
		active_requests = 0
		
		set_block_color()


func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		# Interpolate block's position between initial and final position based on its move_progress
		var target_pos : Vector2 = lerp(Vector2.ZERO, final_position, ease(move_progress, -2.0))
		last_position = block.position
		block.position = target_pos
		
		# Add to move_progress based on move speed and move direction
		move_progress = clamp(move_progress + (move_speed * delta * move_direction / 10.0), 0.0, 1.0)


# Tell a pointer that it should point at the moving block and not the overall scene
func get_pointer_target_pos() -> Vector2:
	return position + block.position


# What if block should do when active and connected
func activate(active : bool) -> void:
	if active:
		active_requests += 1


func add_connected_button(button : ButtonBlock) -> void:
	# Add button that was connected to array
	buttons.append(button)
	buttons_on_colors.append(button.on_color)
	buttons_off_colors.append(button.off_color)


# Update color of block based on connected buttons and which buttons are active
func set_block_color() -> void:
	if len(buttons) == 0:
		set_modulate(Color(1,1,1,1))
	else:
		buttons_on_active_colors.clear()
		var i : int = 0
		if move_direction == 1: # Moving block is on
			# Get connected buttons that are active
			for button in buttons:
				if button.active:
					buttons_on_active_colors.append(buttons_on_colors[i])
				i += 1
			
			target_color = average_colors(buttons_on_active_colors)
					
		else: # Moving block is off
			target_color = average_colors(buttons_off_colors)
	
	# Lerp color towards target color
	set_modulate(lerp(get_modulate(), target_color, color_change_speed))


# Returns average of an array of colors
func average_colors(colors : Array[Color]) -> Color:
	if colors.is_empty():
		return Color(0, 0, 0, 1)  # or whatever default you want
	
	var sum = Color(0, 0, 0, 1)
	for c in colors:
		sum += c
	
	return sum / float(colors.size())
