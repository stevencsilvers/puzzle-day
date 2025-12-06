extends AnimatedSprite2D

@onready var student = get_parent()

var cupcake_anim_played : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !student.can_move:
		# If student has cupcake, show win animation
		if student.has_cupcake and !cupcake_anim_played:
			play("cupcake")
			cupcake_anim_played = true
	else:
		# Flip sprite based on direction of movement
		flip_h = student.input.x < 0
		
		#Change animation based on if student is jumping, running, or idle
		if student.can_move and !student.is_on_floor():
			if student.velocity.y < 0:
				play("jump")
			else:
				play("fall")
		elif student.can_move and student.input.x != 0:
			play("run")
		else:
			play("idle")
