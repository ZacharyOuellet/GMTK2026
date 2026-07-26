class_name ChargeBar
extends ProgressBar


@export var charge_speed: float = 0.5

# get only
var is_charging: bool:
		get: return _is_charging

var _is_charging = false
var _charge_start_time: float

func _process(_delta: float) -> void:
	if (_is_charging): value = compute_power()

func start_charging():
	_charge_start_time = Time.get_ticks_msec()
	_is_charging = true
	visible = true

func compute_power() -> float:
	var elapsed_time: float = Time.get_ticks_msec() - _charge_start_time

	return (-cos(elapsed_time * charge_speed / 1000) + 1) / 2

# Stops charging and returns the power leval (0 to 1)
func stop_charging() -> float:
	visible = false
	_is_charging = false
	return compute_power()