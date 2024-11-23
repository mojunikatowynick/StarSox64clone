extends Area3D

@export var speed: int = 700
@export var dmg: int = 10
@onready var life_timer = $Timer/LifeTimer
@onready var cpu_particles_3d = $Particles/CPUParticles3D


func _ready():
	life_timer.start()
	await get_tree().create_timer(0.1).timeout
	cpu_particles_3d.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, speed) * delta

func _on_life_timer_timeout():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		if "hit" in area:
			area.hit(dmg)
		queue_free()
