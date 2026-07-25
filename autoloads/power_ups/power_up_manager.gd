extends Node3D

@export  var number_of_players: int = 2;
@export var dash_percent_threshold: float = 0.10;
@export var power_shot_percent_threshold: float = 0.30;

enum PowerUpType{DASH, POWER_SHOT}


#  offset between players is the number of power ups
var power_up_trackers: Array[float] = []
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	TimerGlobal.delta_time_percentage.connect(_on_delta_time_percentage)
	TimerGlobal.time_reversed.connect(_on_time_reversed)
	power_up_trackers.resize(number_of_players * PowerUpType.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_delta_time_percentage(delta_time_percent: float) -> void:
	
		for i in range(PowerUpType.size()):
			# if NOT reversed and is first player powers
			if !TimerGloblal._time_is_reversed and i < PowerUpType.size():
				power_up_trackers[i] += delta_time_percent
				power_up_trackers[i + PowerUpType.size()] -= delta_time_percent
			else:
				power_up_trackers[i + PowerUpType.size()] += delta_time_percent
				power_up_trackers[i] -= delta_time_percent

			power_up_trackers[i] -= delta_time_percent

	pass

func _on_time_reversed(is_reversed: bool) -> void:
	pass