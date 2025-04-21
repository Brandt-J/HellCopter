extends RigidBody3D
class_name HeliCopter

var hover_power: float = 100.0
var move_power: float = 5000.0
var rotation_power: float = 13000.0

var target_height: float = 5.0  # meters
var height_increment: float = 10.0  # meters
var adjust_height_time: float = 1.5  # seconds
var turn_angle: float = 30.0  # degrees

@onready var _follow_cam: FollowCamera = $FollowCam


func _ready() -> void:
	_follow_cam.set_node_to_follow(self)


func _input(_event):
	if Input.is_action_just_pressed("Up"):
		target_height += height_increment
	elif Input.is_action_just_pressed("Down"):
		target_height -= height_increment
		

func _physics_process(delta: float) -> void:
	var height: float = global_position.y
	var diff: float = target_height - height
	var multiplier: float = abs(diff) ** 2 / abs(diff)
	var hover_force: Vector3 = Vector3.UP * diff/adjust_height_time * multiplier 
	hover_force -= get_gravity() / 2.0
	hover_force *= hover_power
	
	var move_dir: Vector3 = Vector3(
		_get_forward_vector() * Input.get_axis("Forward", "Backward") + 
		_get_right_vector() * Input.get_axis("StrafeLeft", "StrafeRight")
	)
	var move_force: Vector3 = move_dir * move_power
	
	apply_central_force((hover_force + move_force) * mass * delta)
	
	var move_dir_2d: Vector2 = Input.get_vector("StrafeLeft", "StrafeRight", "Forward", "Backward")		
	var target_rotation: Vector2 = move_dir_2d * turn_angle
	rotation_degrees.x = lerp(rotation_degrees.x, target_rotation.y, 0.9*delta)
	rotation_degrees.z = lerp(rotation_degrees.z, -target_rotation.x, 0.9*delta)
	#rotation_degrees.y = lerp(rotation_degrees.y, 0.0, 0.9*delta)
	
	$Label.text = "Target: %s, Actual: %s" % [target_height, (round(height * 10) / 10)]

	var rotation_axis: float = Input.get_axis("TurnRight", "TurnLeft")
	if Input.is_action_pressed("Backward"):
		rotation_axis *= -1.0
	apply_torque(Vector3.UP * rotation_axis * rotation_power)


func _get_forward_vector() -> Vector3:
	var forward_dir: Vector3 = global_basis.z
	forward_dir.y = 0
	return forward_dir.normalized()
	
	
func _get_right_vector() -> Vector3:
	var right_dir: Vector3 = global_basis.x
	right_dir.y = 0
	return right_dir.normalized()
