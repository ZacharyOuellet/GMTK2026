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

@export_group("")
@export var rotate_speed: float = 0.0


@onready var sand_mat: ShaderMaterial = %sand.get_surface_override_material(0)

var _current_top_id = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_colors(player_on_top)
	player1_color = player1_color
	player2_color = player2_color
	global_fill = global_fill
	TimerGlobal.max_time_wasChanged.connect(_on_max_time_changed)
	TimerGlobal.time_reversed.connect(switch_sides)

func _process(_delta: float) -> void:
	var time: float = TimerGlobal.get_time_as_percentage()
	fill_bias = time if _current_top_id == 1 else (1 - time)

func _set_colors(player_id_on_top: int):
	assert(player_id_on_top == 1 or player_id_on_top == 2)
	_current_top_id = 1
	if (player_id_on_top == 1):
		sand_mat.set_shader_parameter("topColor", player1_color)
		sand_mat.set_shader_parameter("bottomColor", player2_color)
	else:
		sand_mat.set_shader_parameter("topColor", player2_color)
		sand_mat.set_shader_parameter("bottomColor", player1_color)


func switch_sides():
	player_on_top = (player_on_top % 2) + 1
	_set_colors(player_on_top)


func _on_max_time_changed(_new_max_time):
	global_fill = TimerGlobal.get_remaining_total_time_ratio();


func _debug_on_reset_timer():
	TimerGlobal.reset()

func _debug_on_switch_sides():
	TimerGlobal.reverse_time()

func _debug_on_remove_some_time():
	TimerGlobal.set_max_time(TimerGlobal.current_max_time - 1)

func _debug_pause_play():
	TimerGlobal.running = !TimerGlobal.running