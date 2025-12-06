extends Control
class_name MainMenu

# Child references
@onready var levels = $LevelSelect/MarginContainer/HSplitContainer/Levels
@onready var level1 = $LevelSelect/MarginContainer/HSplitContainer/Levels/Level1
@onready var level_manager = $LevelManager
@onready var title = $ThisIsCS50
@onready var level_select = $LevelSelect
@onready var background = $Background
@onready var transition = $Transition

# Array of buttons
@onready var buttons : Array[Button] = [level1]


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Make level buttons
	for i in range(len(level_manager.levels) - 1):
		var button_copy = level1.duplicate()
		button_copy.text = "level " + str(i + 2)
		buttons.append(button_copy)
		levels.add_child(button_copy)
	
	# Connect each button to level manager
	for i in buttons.size():
		if buttons[i] != null:
			buttons[i].pressed.connect(level_manager.load_level.bind(i, true))
	
	# Play This is CS50 sound effect and show level select
	await get_tree().create_timer(1.0).timeout
	AudioManager.play("CS50")
	await get_tree().create_timer(3.0).timeout
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	title.set_visible(false)
	level_select.set_visible(true)
	
	AudioManager.play("Music")


# Set menu elements visible/invisible
func set_menu(show : bool) -> void:
	level_select.set_visible(show)
	background.set_visible(show)
	if (show):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Run when the last level is completed
func win() -> void:
	# This was CS50 splash screen
	title.set_text("This was CS50 (you win)")
	AudioManager.stop("Music")
	title.set_visible(true)
	await get_tree().create_timer(2.0).timeout
	title.set_visible(false)
	
	# Show level select screen again
	set_menu(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioManager.play("Music")


# Quit button quits applicationn
func _on_quit_pressed() -> void:
	get_tree().quit()
