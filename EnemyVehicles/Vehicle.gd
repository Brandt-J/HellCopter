extends VehicleBody3D
class_name Vehicle


var engine_power: float = 2_000.0

var _ontop: bool = true
var _startpos: Vector3
var _max_distance: float = 20.0  # m
var _cur_target: Vector3


func _ready() -> void:
	_startpos = global_position
	_get_new_target()
	

func _process(delta: float) -> void:
	_cur_target.y = global_position.y
	var target_dir: Vector3 = _cur_target - global_position
	var target_dist: float = _cur_target.distance_to(global_position)
	var dist_max_speed: float = 5.0	
	
	# Forward/Backward
	if target_dir.dot(global_basis.z) < 0:
		engine_force = lerp(0.0, engine_power, clamp(target_dist/dist_max_speed, 0.0, 1.0))
	else:
		engine_force = -engine_power/2
	

	if target_dir.dot(global_basis.x) < 0:
		steering = lerp(steering, 0.4, 0.9*delta)
	else:
		steering = lerp(steering, -0.4, 0.9*delta)
		
	if target_dist <= 3.0:
		_get_new_target()


func _physics_process(delta):
	if global_position.y < -1 and _ontop:
		_ontop = false
		print(name, " dropped throught floor ", Time.get_ticks_msec())
	

func _get_new_target() -> void:
	randomize()
	_cur_target = Vector3(
		randf_range(_startpos.x-_max_distance, _startpos.x+_max_distance),
		global_position.y,
		randf_range(_startpos.z-_max_distance, _startpos.z+_max_distance))
	
