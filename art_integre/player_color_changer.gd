@tool
extends Node3D

@export var meshes_to_change: Array[MeshInstance3D]
@export var material: Material:
	set(value):
		material = value
		_update_material()

@export_tool_button("Refresh materials") var refresh_button = _update_material

func _update_material():
	print(material)
	for mesh in meshes_to_change:
			mesh.set_surface_override_material(0, material)