extends Node3D
@export var max_time : float = 20;
var half_time : float;
var _currentTime : float = 0;

signal max_time_wasChanged(new_time)
signal game_over()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	half_time = max_time / 2.0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_currentTime += delta
	if _currentTime >= max_time or _currentTime < 0:
		game_over.emit()
	# time_wasChanged.emit(_currentTime)
	print(_currentTime)

func set_max_time(new_time: float) -> void:
	max_time = new_time
	half_time = max_time / 2.0
	max_time_wasChanged.emit(new_time)