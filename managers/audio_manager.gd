extends Node


# Plays audio stream of name
func play(name : String) -> void:
	# Finds audiostream with matching name
	var target_stream : AudioStreamPlayer = get_node(name)
	
	# No audio stream with matching name
	if (target_stream == null):
		printerr("<AudioManager> Cannot find sfx named: ", name)
		return
	
	if (target_stream is AudioStreamPlayerPlus):
		target_stream.play_plus()
	else:
		target_stream.play()


# Stops audio stream of name
func stop(name : String) -> void:
	var target_stream : AudioStreamPlayer = get_node(name)
	
	if (target_stream == null):
		printerr("<AudioManager> Cannot find sfx named: ", name)
		return
	
	target_stream.stop()
