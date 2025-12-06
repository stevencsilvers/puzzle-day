extends Area2D



func _process(_delta : float) -> void:
	# If Area 2D is overlapping tilemap or moving block, then player is stuck
	if get_overlapping_bodies().size() > 0:
		get_parent().poof()
