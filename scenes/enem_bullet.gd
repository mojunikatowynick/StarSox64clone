extends Area3D

@export var speed: int = 10
@export var dmg: int = 10
@onready var life_timer = $Timer/LifeTimer

func _ready():
	life_timer.start()
	$AnimationPlayer.play("Pulse")

func _process(delta):
	position += transform.basis * Vector3(0, 0, speed) * delta

func _on_life_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if "hit" in body and body.is_in_group("Fox"):
		body.hit(dmg)
		queue_free()
