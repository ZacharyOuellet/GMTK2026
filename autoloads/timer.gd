extends Node
@export var initial_max_time: float = 30;


var is_running = false:
		set(value):
			is_running = value
			toggled_play_pause.emit(is_running)

var current_max_time: float
var half_time: float;
var _currentTime: float = 0;

var _time_direction: Enums.TimeDirection = Enums.TimeDirection.FORWARD;

signal max_time_wasChanged(new_max_time: float)
signal delta_time_percentage(delta_time_percent: float)
signal currentTime_percentage(_current_time_percent: float)
signal time_out()
signal time_reversed(_time_direction: Enums.TimeDirection)
signal toggled_play_pause(is_running: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if (!is_running): return

	var delta_time = 0;

	match _time_direction:
		Enums.TimeDirection.FORWARD:
			delta_time = dt;
		Enums.TimeDirection.BACKWARD:
			delta_time = - dt;
	_emit_delta_time_as_percentage(delta_time);
	_currentTime += delta_time
	currentTime_percentage.emit(get_time_as_percentage());
	if _currentTime >= current_max_time or _currentTime < 0:
		time_out.emit();
		is_running = false


func set_max_time(new_time: float) -> void:
	current_max_time = new_time;
	half_time = current_max_time / 2.0;
	max_time_wasChanged.emit(new_time);


func get_time_as_percentage() -> float:
	return _currentTime / current_max_time;

func get_remaining_total_time_ratio() -> float:
	return current_max_time / initial_max_time

func reverse_time() -> void:
	match _time_direction:
		Enums.TimeDirection.FORWARD:
			_time_direction = Enums.TimeDirection.BACKWARD;
		Enums.TimeDirection.BACKWARD:
			_time_direction = Enums.TimeDirection.FORWARD;
	time_reversed.emit(_time_direction);

func reset() -> void:
	set_max_time(initial_max_time)
	_currentTime = half_time
	is_running = true


func _emit_delta_time_as_percentage(delta_time: float) -> void:
	delta_time_percentage.emit(delta_time / current_max_time);

func get_time_direction() -> Enums.TimeDirection:
	return _time_direction;