extends AudioStreamPlayer
class_name AudioStreamPlayerPlus

# Parameters
@export var sfxs : Array[AudioStreamWAV]
@export_range(0.0, 0.5, 0.01) var pitch_rand : float = 0.0
@export_range(0.0, 2, 0.01) var volume_rand : float = 0.0
@export var loop : bool = false

# Original values of sound
@onready var og_pitch = get_pitch_scale()
@onready var og_volume = get_volume_db()


func _ready() -> void:
	# If loop is on, play sound again whenever it is finished
	if loop:
		finished.connect(play_plus)


func play_plus() -> void:
	# If multiple sound effects are in the sfx array, randomize which sound to play
	if (sfxs.size() > 0):
		set_stream(sfxs[randi_range(0, sfxs.size() - 1)])
	
	# Randomize pitch/volume
	if (pitch_rand != 0.0):
		set_pitch_scale(og_pitch + randf_range(-pitch_rand, pitch_rand))
	if (volume_rand != 0.0):
		set_volume_db(og_volume + randf_range(-volume_rand, volume_rand))
	
	play()
