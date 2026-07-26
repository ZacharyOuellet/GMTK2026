extends Node3D

var player_on_top: int = 1;


@export_group("Shader settings")
@export_color_no_alpha var player1_color := Color(1, 0, 0):
		set(value):
			player1_color = value
			if (is_node_ready()): _set_colors(player_on_top)

@export_color_no_alpha var player2_color := Color(0, 0, 1):
		set(value):
			player2_color = value
			if (is_node_ready()): _set_colors(player_on_top)

@export_range(0, 1, 0.01) var global_fill := 1.0:
		set(value):
			global_fill = value
			if (is_node_ready()): sand_mat.set_shader_parameter("globalFill", value)

@export_range(0, 1, 0.01) var fill_bias := 1.0:
		set(value):
			fill_bias = value
			if (is_node_ready()): sand_mat.set_shader_parameter("sideBias", value)

@export_group("Rotation")
@export var enable_spins_on_pause: bool
@export var spin_speed: float = 0.0

var _current_spin_speed: float = 0.0

@onready var sand_mat: ShaderMaterial = %Sand.get_surface_override_material(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_colors(player_on_top)
	player1_color = player1_color
	player2_color = player2_color
	global_fill = global_fill
	TimerGlobal.max_time_wasChanged.connect(_on_max_time_changed)
	TimerGlobal.time_reversed.connect(switch_sides)
	TimerGlobal.toggled_play_pause.connect(_on_timer_play_pause)


func _process(delta: float) -> void:
	var time: float = TimerGlobal.get_time_as_percentage()
	if(_current_spin_speed > 0.1):
		fill_bias = 0.5
	else:
		fill_bias = time if player_on_top == 2 else (1 - time)

	if(enable_spins_on_pause): rotate_z(_current_spin_speed * delta)


func _set_colors(player_id_on_top: int):
	assert(player_id_on_top == 1 or player_id_on_top == 2)
	if (player_id_on_top == 1):
		sand_mat.set_shader_parameter("topColor", player1_color)
		sand_mat.set_shader_parameter("bottomColor", player2_color)
	else:
		sand_mat.set_shader_parameter("topColor", player2_color)
		sand_mat.set_shader_parameter("bottomColor", player1_color)


func switch_sides(time_direction : Enums.TimeDirection):
	if(time_direction == Enums.TimeDirection.FORWARD):
		player_on_top = 1
	else:
		player_on_top = 2
	_set_colors(player_on_top)


func _on_max_time_changed(_new_max_time):
	global_fill = TimerGlobal.get_remaining_total_time_ratio();


func _on_timer_play_pause(is_running: bool):
	if(is_running):
		rotation = Vector3.ZERO
		_current_spin_speed = 0
	else:
		_current_spin_speed = spin_speed


## DEBUGGING
func _debug_on_reset_timer():
	TimerGlobal.reset()

func _debug_on_switch_sides():
	TimerGlobal.reverse_time()

func _debug_on_remove_some_time():
	TimerGlobal.set_max_time(TimerGlobal.current_max_time - 1)

func _debug_pause_play():
	TimerGlobal.is_running = !TimerGlobal.is_running
