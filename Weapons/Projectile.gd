extends Area3D
class_name Projectile

var damage: float = 20.0
var speed: float = 10  # m/s


static func get_projectile(projectile_damage: float, projectile_speed: float) -> Projectile:
	var scene_path: String = "res://Weapons/Projectile.tscn"
	var projectile: Projectile = load(scene_path).instantiate()
	projectile.speed = projectile_speed
	projectile.damage = projectile_damage
	return projectile
	

func _physics_process(delta: float):
	global_position -= global_basis.z * speed * delta
	

func _on_body_entered(body):
	for child in body.get_children():
		if child is PawnProperties:
			child = child as PawnProperties
			child.receive_damage(damage)
			break
			
	ProjectilePool.remove_projectile(self)
