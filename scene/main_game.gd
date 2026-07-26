extends Node3D

@export_group("Time settings")
@export var initial_global_time_pool: float = 20.0
@export var max_time_loss_per_hit: float = 2.0
@export_range(0, 1, 0.05) var time_loss_percentage_per_hit: float = 0.1

@export_group("Faceoff settings")
@export var min_xz_force: float = 3
@export var max_xz_force: float = 8
@export var y_force: float = 5
@export var torque: Vector3 = Vector3(0, 0, 4)

@export_group("Internal nodes")
@export var hourglass: Hourglass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_game()
	execute_startup_sequence()


func initialize_game():
	TimerGlobal.initial_max_time = initial_global_time_pool
	TimerGlobal.reset()
	TimerGlobal.is_running = false
	TimerGlobal.time_out.connect(_on_timeout)

func execute_startup_sequence():
	_on_hourglass_hit(randi_range(1, 2)) # Set random player to start
	# TODO COUNTDOWN

	var xz_force := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * randf_range(min_xz_force, max_xz_force)
	var force := Vector3(xz_force.x, y_force, xz_force.y)
	hourglass.hit(force, torque)

func _on_timeout():
	LevelManager.go_to_win_game(_get_player_on_bottom())

func _get_player_on_top() -> int:
	return 1 if TimerGlobal.get_time_direction() == Enums.TimeDirection.FORWARD else 2

func _get_player_on_bottom() -> int:
	return 2 if TimerGlobal.get_time_direction() == Enums.TimeDirection.FORWARD else 1

func _on_hourglass_hit(playerId: int):
	if (_get_player_on_top() == playerId): TimerGlobal.reverse_time()
	var time_loss = TimerGlobal.current_max_time * time_loss_percentage_per_hit
	time_loss = min(time_loss, max_time_loss_per_hit)
	TimerGlobal.set_max_time(TimerGlobal.current_max_time - time_loss)
