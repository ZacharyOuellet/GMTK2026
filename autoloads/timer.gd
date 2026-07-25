extends Node
@export var initial_max_time: float = 20;

var running = false

var current_max_time: float
var half_time: float;
var _currentTime: float = 0;

var _reverse_time: bool = false;
signal max_time_wasChanged(new_max_time: float)
signal delta_time_percentage(delta_time_percent: float)
signal currentTime_percentage(_current_time_percent: float)
signal time_out()
signal time_reversed(is_reversed: bool)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if (!running): return

	var delta_time = 0;

	if !_reverse_time:
		delta_time = dt;
	else:
		delta_time = - dt;

	_emit_delta_time_as_percentage(delta_time);
	_currentTime += delta_time
	currentTime_percentage.emit(get_time_as_percentage());
	print(get_time_as_percentage())
	if _currentTime >= current_max_time or _currentTime < 0:
		time_out.emit();
		running = false


func set_max_time(new_time: float) -> void:
	current_max_time = new_time;
	half_time = current_max_time / 2.0;
	max_time_wasChanged.emit(new_time);


func get_time_as_percentage() -> float:
	return _currentTime / current_max_time;

func get_remaining_total_time_ratio() -> float:
	print(current_max_time / initial_max_time)
	return current_max_time / initial_max_time

func reverse_time() -> void:
	_reverse_time = !_reverse_time;
	time_reversed.emit();

func reset() -> void:
	set_max_time(initial_max_time)
	_currentTime = half_time
	running = true


func _emit_delta_time_as_percentage(delta_time: float) -> void:
	delta_time_percentage.emit(delta_time / current_max_time);