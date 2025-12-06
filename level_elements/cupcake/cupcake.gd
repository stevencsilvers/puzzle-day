extends Node2D

@onready var level = get_tree().get_first_node_in_group("level")


# if player collides with cupcake, tell level that a cupcake has been collected and by which player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Duck and !level.duck_has_cupcake:
		level.cupcake_collected(true)
		body.collect_cupcake()
		collect()
	if body is Student and !level.student_has_cupcake:
		level.cupcake_collected(false)
		body.collect_cupcake()
		collect()
	if body is Oscar:
		collect()


# Run when cupcake is collected
func collect() -> void:
	AudioManager.play("Chomp")
	queue_free()
