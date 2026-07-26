@tool
extends Node3D

@export var meshes_to_change: Array[MeshInstance3D]
@export var material: Material:
	set(value):
		material = value
		_update_material()


@export var run_anim: AnimationPlayer
@export var hit_anim: AnimationPlayer

@export_tool_button("Refresh materials") var refresh_button = _update_material
@export_tool_button("run") var r = run
@export_tool_button("stop") var stop_run = stop_running
@export_tool_button("hit") var h = hit


var _is_running = false
var _is_hitting = false
func _update_material():
	print(material)
	for mesh in meshes_to_change:
			mesh.set_surface_override_material(0, material)

func run():
	if (_is_running): return
	_is_running = true
	if(_is_hitting): return
	run_anim.play("runCycle")

func stop_running():
	if (!_is_running): return
	_is_running = false

	if(_is_hitting): return
	run_anim.stop()
	hit_anim.play("hitCycle")
	hit_anim.stop()

func hit():
	_is_hitting = true
	run_anim.stop()
	hit_anim.play("hitCycle")
	await hit_anim.animation_finished
	_is_hitting = false
	if (_is_running):
		run_anim.play("runCycle")
