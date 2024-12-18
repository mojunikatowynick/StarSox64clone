extends Node3D

func _ready():
	scale = Vector3(2,2,2)
	$SpriteEx.rotation_degrees.z = (randf_range(-360,360))
