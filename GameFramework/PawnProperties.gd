extends Node3D
class_name PawnProperties

@export var hitpoints: float = 100.0
signal died

func _process(_delta: float) -> void:
	$Label3D.text = str(hitpoints) + " HP"


func receive_damage(damage: float) -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		died.emit()
	
