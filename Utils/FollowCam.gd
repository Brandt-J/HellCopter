extends Node3D
class_name FollowCamera


var _node_to_follow: Node3D
@export var camera_distance: float = 25.0
@export var camera_height: float = 10.0
@onready var _camera_3d = $Camera3D


func set_node_to_follow(node_to_follow: Node3D) -> void:
	_node_to_follow = node_to_follow


func _process(_delta: float):
	if is_instance_valid(_node_to_follow):
		_camera_3d.global_position = _node_to_follow.global_position + Vector3(0.0, camera_height, camera_distance)
	
