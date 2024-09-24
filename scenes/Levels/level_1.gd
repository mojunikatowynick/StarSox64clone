extends Node3D

@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D


var prog_speed = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_3d.progress += 100 * delta
	print(path_follow_3d.progress)
