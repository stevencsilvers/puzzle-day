extends RayCast2D

@onready var parent = get_parent()


var moving_block_collider


func _physics_process(_delta: float) -> void:
	# If on a moving block, add block's velocity to player
	moving_block_collider = get_collider()
	if moving_block_collider != null:
		parent.position += moving_block_collider.position - moving_block_collider.get_parent().last_position
