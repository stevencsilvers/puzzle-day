extends Node2D

@onready var student = get_parent()

# Particle references
@onready var run = $Run



func _process(_delta: float) -> void:
	# Make run dust particles show when player is grounded and moving
	run.set_emitting(student.is_on_floor() and student.velocity.x != 0 and student.can_move)


# Spawn jump dust effect at player's feet
func jump_effect() -> void:
	$Jump.play()


func poof_effect() -> void:
	$Poof.play()


func confetti_effect() -> void:
	$Confetti.play()
