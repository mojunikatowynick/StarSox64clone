extends Area3D

@onready var ring = $"."

func _ready():
	ring.scale = Vector3(0.5, 0.5, 0.5)
	ring.visible = false

func _on_body_entered(body):
	if body.is_in_group("Fox"):
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("Trigger"):
			ring.visible = true
			var tween = get_tree().create_tween()
			tween.tween_property(ring, "scale", Vector3.ONE, 1)
