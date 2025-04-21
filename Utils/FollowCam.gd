extends Node3D
class_name FollowCamera


var _node_to_follow: Node3D
@export var camera_distance: float = 25.0
@export var camera_height: float = 10.0
@export var look_at_offset: float = 10.0
@onready var _camera_3d = $Camera3D


func set_node_to_follow(node_to_follow: Node3D) -> void:
	_node_to_follow = node_to_follow


func _process(delta: float):
	if is_instance_valid(_node_to_follow):
		var pos: Vector3 = _node_to_follow.to_global(Vector3(0, camera_height, camera_distance))
		_camera_3d.global_position = lerp(_camera_3d.global_position, pos, 0.95*delta)
		_camera_3d.look_at(_node_to_follow.global_position - _node_to_follow.global_basis.z*look_at_offset)
