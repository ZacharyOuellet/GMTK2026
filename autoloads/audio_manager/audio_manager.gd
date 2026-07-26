extends Node3D

@export var number_of_audio_players: int = 7
@export_group("Audio streams")
@export var hit_audio_stream: AudioStream
@export var dash_audio_stream: AudioStream
@export var bounce_audio_stream: AudioStream
@export var hit_ground_audio_stream: AudioStream
@export var move_audio_stream: AudioStream


enum AudioType {
	HIT,
	DASH,
	BOUNCE,
	HIT_GROUND,
	MOVE
}

var audio_players: Array[AudioStreamPlayer3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for _i in range(number_of_audio_players):
		var audio_player = AudioStreamPlayer3D.new()
		add_child(audio_player)
		audio_players.append(audio_player)

func _play_audio(audio_stream: AudioStream) -> void:
	for audio_player in audio_players:
		if !audio_player.playing:
			audio_player.stream = audio_stream
			audio_player.play()
			return

func play_audio_by_type(audio_type: AudioType) -> void:
	print("Playing audio of type: %s" % audio_type)
	match audio_type:
		AudioType.HIT:
			_play_audio(hit_audio_stream)
		AudioType.DASH:
			_play_audio(dash_audio_stream)
		AudioType.BOUNCE:
			_play_audio(bounce_audio_stream)
		AudioType.HIT_GROUND:
			_play_audio(hit_ground_audio_stream)
		AudioType.MOVE:
			_play_audio(move_audio_stream)
