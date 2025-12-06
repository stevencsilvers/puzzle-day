extends Area2D

# Keep track of the element that player is currently touching
var touching_element = null

@onready var parent = get_parent()


func _on_body_entered(body: Node2D) -> void:
	touching_element = body.get_parent()
	
	# Set moving block to be lit up
	if parent.pointing:
		body.set_modulate(Color(1,1,1,1))


func _on_body_exited(body: Node2D) -> void:
	# Set moving block to be dim
	if parent.pointing:
		body.set_modulate(Color(0.8,0.8,0.8,1))
	
	touching_element = null
