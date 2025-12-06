extends Node2D


var duck_has_cupcake : bool = false
var student_has_cupcake : bool = false

var level_completed : bool = false

# Colors for if blocks
@export var button_colors : Array[Color]


func _ready() -> void:
	set_button_colors()


# Constantly check if both cupcakes have been collected
func _process(_delta : float) -> void:
	if !level_completed and duck_has_cupcake and student_has_cupcake:
		level_complete()


func _unhandled_input(event) -> void:
	# Press R to reset current level
	if !(get_parent() is LevelManager) and event.is_action_pressed("reset"):
		get_tree().reload_current_scene()


# Keep track of which player has collected a cupcake
func cupcake_collected(duck : bool) -> void:
	if duck:
		duck_has_cupcake = true
	else:
		student_has_cupcake = true


# Run when both cupcakes are collected
func level_complete():
	level_completed = true
	
	# Wait 1 second before moving on to next level
	await get_tree().create_timer(1.0).timeout
	
	if get_parent() is LevelManager:
		get_parent().next_level()


# Set color of all buttons
func set_button_colors() -> void:
	var counter : int = 0
	for button in get_tree().get_nodes_in_group("button"):
		if counter + 1 <= len(button_colors):
			button.set_on_off_color(button_colors[counter], button_colors[counter + 1])
			counter += 2
