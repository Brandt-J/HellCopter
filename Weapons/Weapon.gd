extends Node3D
class_name Weapon

@export_flags_3d_physics var autoaim_collision
@export var autoaim_distance: float = 30.0
@export var autoaim: bool = true
@export var autofire: bool = true
@export var fire_delay: float = 0.2  # seconds
@export var projectile_speed: float = 20.0
@export var projectile_damage: float = 20.0

@onready var _area: Area3D = $Area3D
@onready var _area_shape: CollisionShape3D = $Area3D/CollisionShape3D
@onready var _weapon_mesh: MeshInstance3D = $WeaponMesh
@onready var _autoaim_update_timer: Timer  = $AutoaimUpdateTimer
@onready var _fire_timer: Timer = $FireTimer
@onready var _fire_stream_player = $AudioStreamPlayer3D

var _closest_target: Node3D
var _is_firing: bool = false


func _ready() -> void:
	_area.collision_mask = autoaim_collision
	var sphere: SphereShape3D = _area_shape.shape as SphereShape3D
	sphere.radius = autoaim_distance
	if autoaim:
		_autoaim_update_timer.start()


func _process(_delta: float) -> void:
	if autoaim and is_instance_valid(_closest_target):
		_weapon_mesh.look_at(_closest_target.global_position)
		if autofire:
			_is_firing = true
	else:
		_is_firing = false
	
	_handle_firing()
	
	
func _handle_firing() -> void:
	if _is_firing and _fire_timer.is_stopped():
		_fire_projectile()
		_fire_timer.start(fire_delay)
	elif not _fire_timer.is_stopped() and not _is_firing:
		_fire_timer.stop()
	
	
func _fire_projectile() -> void:
	ProjectilePool.add_projectile_to(_weapon_mesh, projectile_damage, projectile_speed)
	_fire_stream_player.play()


func _on_autoaim_update_timer_timeout():
	var targets_in_range: Array[Node3D] = _area.get_overlapping_bodies()
	if targets_in_range.size() == 0:
		_closest_target = null
		return
		
	var closest_distance: float = INF
	for target in targets_in_range:
		if global_position.distance_to(target.global_position) < closest_distance:
			_closest_target = target
