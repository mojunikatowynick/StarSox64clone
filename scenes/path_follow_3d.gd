extends PathFollow3D

func _process(delta):
	if get_child(0).alive:
		progress += 20 * delta

func reset_enemy_pos():
	progress = 0
