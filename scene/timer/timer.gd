extends Node3D
@export var max_time : float = 20;
var half_time : float;
var _currentTime : float = 0;

var _reverse_time : bool = false;
signal max_time_wasChanged(new_time)
signal delta_time_percentage(delta_time)
signal time_out()
signal time_reversed()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	half_time = max_time / 2.0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var delta_time = 0;

	if !_reverse_time:
		delta_time = delta;
	else:
		delta_time = -delta;

	emit_delta_time_as_percentage(delta_time);
	_currentTime += delta_time
	if _currentTime >= max_time or _currentTime < 0:
		time_out.emit();
	# print(_currentTime)


func set_max_time(new_time: float) -> void:
	max_time = new_time;
	half_time = max_time / 2.0;
	max_time_wasChanged.emit(new_time);


func get_time_as_percentage() -> float:
	return _currentTime / max_time;


func emit_delta_time_as_percentage(delta_time: float) -> void:
	delta_time_percentage.emit(delta_time / max_time);
	print("delta time percentage: " + str(delta_time / max_time));

func reverse_time() -> void:
	_reverse_time = !_reverse_time;
	time_reversed.emit();
