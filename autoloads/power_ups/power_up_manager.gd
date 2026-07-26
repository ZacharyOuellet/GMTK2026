extends Node3D

@export  var number_of_players: int = 2;
@export var dash_percent_threshold: float = 0.10;
@export var power_shot_percent_threshold: float = 0.30;

enum PowerUpType{DASH, POWER_SHOT}
@export var PowerUpThresholds: Array[float] = [0.10, 0.30]

signal playerHasPowerUp(player_id: int, power_up_type: PowerUpType)

#  offset between players is the number of power ups
var power_up_trackers: Array[float] = []
var power_up_locks: Array[int] = []

# 0: power is available to use, 1: power is not available


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimerGlobal.delta_time_percentage.connect(_on_delta_time_percentage)
	power_up_trackers.resize(number_of_players * PowerUpType.size())
	power_up_locks.resize(number_of_players * PowerUpType.size())
	reset_power_ups()

func reset_power_ups() -> void:
	for i in range(power_up_trackers.size()):
		power_up_trackers[i] = 0
		power_up_locks[i] = 1


func _on_delta_time_percentage(delta_time_percent: float) -> void:
	
	for i in range(PowerUpType.size()):
		# if NOT reversed and is first player powers
		var  P1_power_up_index = i
		var  P2_power_up_index = i + PowerUpType.size()
		power_up_trackers[P1_power_up_index] = clamp(power_up_trackers[P1_power_up_index], 0, 1)
		power_up_trackers[P2_power_up_index] = clamp(power_up_trackers[P2_power_up_index], 0, 1)
		
			# slightly scuffed as instead of preventing operatiion I am just multiplying by 0. Will change if time permits
			# just usings ifs is probably better but I am lazy :P 
		power_up_trackers[P1_power_up_index] += delta_time_percent * power_up_locks[P1_power_up_index]
		power_up_trackers[P2_power_up_index] -= delta_time_percent * power_up_locks[P2_power_up_index]


		if power_up_trackers[P1_power_up_index] >= PowerUpThresholds[i] and power_up_locks[P1_power_up_index] == 1:
			print("Player 1 has power up %d" % i)
			givePowerUp(1, i)
		if power_up_trackers[P2_power_up_index] >= PowerUpThresholds[i] and power_up_locks[P2_power_up_index] == 1:
			print("Player 2 has power up %d" % i)
			givePowerUp(2, i)


func givePowerUp(player_id: int, power_up_type: PowerUpType) -> void:
	var index = (player_id - 1) * PowerUpType.size() + power_up_type
	power_up_trackers[index] = 0
	# print("Player %d has power up %d" % [player_id, power_up_type])
	playerHasPowerUp.emit(player_id, power_up_type)
	_lock_power_up(player_id, power_up_type)

func reset_power_up(player_id: int, power_up_type: PowerUpType) -> void:
	var index = (player_id - 1) * PowerUpType.size() + power_up_type
	power_up_trackers[index] = 0
	_unlock_power_up(player_id, power_up_type)
	
func _lock_power_up(player_id: int, power_up_type: PowerUpType) -> void:
	var index = (player_id - 1) * PowerUpType.size() + power_up_type
	power_up_locks[index] = 0
	# print("locked power up %d for player %d" % [power_up_type, player_id])

func _unlock_power_up(player_id: int, power_up_type: PowerUpType) -> void:
	var index = (player_id - 1) * PowerUpType.size() + power_up_type
	power_up_locks[index] = 1
	# print("unlocked power up %d for player %d" % [power_up_type, player_id])

# 0: power is available to use, 1: power is not available
func is_power_up_available(player_id: int, power_up_type: PowerUpType) -> bool:
	# print("Checking if power up %d is available for player %d" % [power_up_type, player_id])
	var index = (player_id - 1) * PowerUpType.size() + power_up_type
	# print("power_up_locks[%d] = %d" % [index, power_up_locks[index]])
	# print(power_up_locks[index] == 0)
	return power_up_locks[index] == 0


func get_power_up_percentage(player_id: int, power_up_type: PowerUpType) -> float:
	var index = (player_id - 1) * PowerUpType.size() + power_up_type
	return power_up_trackers[index]/PowerUpThresholds[power_up_type]
