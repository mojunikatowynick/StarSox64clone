extends PathFollow3D


func _process(delta):
	if progress_ratio < 0.9:
		progress += 20 * delta
