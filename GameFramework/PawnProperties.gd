extends Node3D
class_name PawnProperties

var hitpoints: float = 100.0


func _process(_delta: float) -> void:
	$Label3D.text = str(hitpoints) + " HP"
