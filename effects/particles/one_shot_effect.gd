extends GPUParticles2D


# Play effect and move to higher up in tree to not disappear/be affected by parent movement
func play() -> void:
	# Create copy of particle effect
	var copy = duplicate()
	# Add to tree so that it doesn't follow player
	get_tree().get_first_node_in_group("level").add_child(copy)
	copy.position = global_position
	# Play particle effect
	copy.set_emitting(true)
