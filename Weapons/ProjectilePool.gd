extends Node

var _free_projectiles: Array[Projectile] = []
var _max_pool_size: int = 100
var _projectiles_to_remove: Array[Projectile] = []


func add_projectile_to(parent: Node3D, damage: float, speed: float) -> void:
	var projectile: Projectile
	if _free_projectiles.size() > 0:
		projectile = _free_projectiles.pop_front() as Projectile
		projectile.damage = damage
		projectile.speed = speed
	else:
		projectile = Projectile.get_projectile(damage, speed)
	
	parent.add_child(projectile)
	projectile.set_owner(parent)
	projectile.process_mode = Node.PROCESS_MODE_INHERIT
	

func remove_projectile(projectile: Projectile) -> void:
	_projectiles_to_remove.append(projectile)  # don't remove directly from parent, this is not allowed in physics_process (which calls this function here)
	
	
func _process_projectiles_to_remove() -> void:
	for projectile in _projectiles_to_remove:
		if is_instance_valid(projectile):
			if is_instance_valid(projectile.get_parent()):
				projectile.get_parent().remove_child(projectile)

			projectile.process_mode = Node.PROCESS_MODE_DISABLED
		
			_free_projectiles.append(projectile)
			if _free_projectiles.size() > _max_pool_size:
				_free_projectiles.pop_front().queue_free()

	_projectiles_to_remove = []
