extends Node3D

@export var number_of_audio_players: int = 7
@export_group("sounds")
@export var hit_audio_stream: AudioStreamMP3
@export var hit_audio_volume: float = 1.0
@export var dash_audio_stream: AudioStreamMP3
@export var dash_audio_volume: float = 1.0
@export var bounce_audio_stream: AudioStreamMP3
@export var bounce_audio_volume: float = 1.0
@export var hit_ground_audio_stream: AudioStreamMP3
@export var hit_ground_audio_volume: float = 1.0
@export var move_audio_stream: AudioStreamMP3
@export var move_audio_volume: float = 1.0
@export_group("music")
@export var music_audio_stream: AudioStreamMP3
@export var music_audio_volume: float = 1.0


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
	_play_audio(music_audio_stream, music_audio_volume, true)

func _play_audio(
	audio_stream: AudioStreamMP3,
	normalized_volume: float,
	loop: bool = false
) -> void:
	for audio_player in audio_players:
		if !audio_player.playing:
			audio_stream.loop = loop
			audio_player.stream = audio_stream
			audio_player.volume_db = linear_to_db(normalized_volume)
			audio_player.play()
			return

func play_audio_by_type(audio_type: AudioType) -> void:
	print("Playing audio of type: %s" % audio_type)
	match audio_type:
		AudioType.HIT:
			_play_audio(hit_audio_stream, hit_audio_volume)
		AudioType.DASH:
			_play_audio(dash_audio_stream, dash_audio_volume)
		AudioType.BOUNCE:
			_play_audio(bounce_audio_stream, bounce_audio_volume)
		AudioType.HIT_GROUND:
			_play_audio(hit_ground_audio_stream, hit_ground_audio_volume)
		AudioType.MOVE:
			_play_audio(move_audio_stream, move_audio_volume)
