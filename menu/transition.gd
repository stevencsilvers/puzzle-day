extends ColorRect

@export var duration : float = 0.25


func fade(shown : bool):
	# Fade the transition screen to black/transparent
	var tween = get_tree().create_tween()
	if shown:
		tween.tween_property(self, "color", Color(0,0,0,1), duration)
	else:
		tween.tween_property(self, "color", Color(0,0,0,0), duration)
