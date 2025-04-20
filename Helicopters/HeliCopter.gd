extends RigidBody3D
class_name HeliCopter

var hover_power: float = 100.0
var move_power: float = 3000.0
var target_height: float = 5.0
var adjust_height_time: float = 1.5  # seconds
var turn_angle: float = 30.0  # degrees

@onready var _follow_cam: FollowCamera = $FollowCam


func _ready() -> void:
	_follow_cam.set_node_to_follow(self)


func _input(event):
	if Input.is_action_just_pressed("Up"):
		target_height += 5
	elif Input.is_action_just_pressed("Down"):
		target_height -= 5
		

func _physics_process(delta: float) -> void:
	var height: float = global_position.y
	var diff: float = target_height - height
	var multiplier: float = abs(diff) ** 2 / abs(diff)
	var hover_force: Vector3 = Vector3.UP * diff/adjust_height_time * multiplier 
	hover_force -= get_gravity() / 2.0
	hover_force *= hover_power
	
	var move_dir_2d: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")	
	var target_rotation: Vector2 = move_dir_2d * turn_angle
	rotation_degrees.x = lerp(rotation_degrees.x, target_rotation.y, 0.9*delta)
	rotation_degrees.z = lerp(rotation_degrees.z, -target_rotation.x, 0.9*delta)

	var move_dir: Vector3 = Vector3(move_dir_2d.x, 0, move_dir_2d.y)
	var move_force: Vector3 = move_dir * move_power
	
	apply_central_force((hover_force + move_force) * mass * delta)
	
	$Label.text = "Target: %s, Actual: %s" % [target_height, (round(height * 10) / 10)]
