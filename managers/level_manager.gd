extends Node
class_name LevelManager

# Array with order of levels
@export var levels : Array[PackedScene] = []

var completed_levels : int = 0

# Keep track of current level
var current_level_index : int = -1 # -1 if not in level
var current_level_instance = null

@onready var menu = get_parent()


func _ready() -> void:
	if not (menu is MainMenu):
		menu = null
		load_level(0)


# Move to next level
func next_level() -> void:
	completed_levels += 1
	load_level(current_level_index + 1)


func load_level(index : int, from_button : bool = false) -> void:
	if (index < len(levels)):
		# Click button sound effect
		if from_button:
			AudioManager.play("ButtonOn")
		
		# Transition fade in/out
		if menu != null:
			menu.transition.fade(true)
			await get_tree().create_timer(menu.transition.duration).timeout
		
		if menu != null:
			menu.set_menu(false)
		
		remove_child(current_level_instance)
		
		var scene_instance = levels[index].instantiate()
		add_child(scene_instance)
		
		current_level_index = index
		current_level_instance = scene_instance
		
		# Make mouse cursor invisible
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		# Transition fade in/out
		if menu != null:
			menu.transition.fade(false)
	else:
		# Show wn screen since level index is out of bounds
		remove_child(current_level_instance)
		current_level_index = -1
		menu.win()


# Press R to reset current level
func _unhandled_input(event):
	if current_level_index >= 0 and event.is_action_pressed("reset"):
		load_level(current_level_index)
	
	if menu != null and current_level_index >= 0 and event.is_action_pressed("menu"):
		menu.set_menu(true)
		current_level_index = -1
		remove_child(current_level_instance)
