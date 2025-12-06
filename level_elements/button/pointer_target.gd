extends Line2D


@onready var if_block = get_parent()
@onready var arrow = $Arrow


func _process(_delta: float) -> void:
	if visible and if_block.target_element != null:
		var pointer_end = if_block.target_element.get_pointer_target_pos() - if_block.position
		pointer_end -= pointer_end.normalized() * 8
		set_point_position(1, pointer_end)
		
		# Set arrow sprite's position to end of line2d and set rotation to be in correct direction
		arrow.position = pointer_end
		arrow.rotation = atan2(pointer_end.y, pointer_end.x) + deg_to_rad(135)


func set_shown(shown : bool) -> void:
	set_visible(shown)
