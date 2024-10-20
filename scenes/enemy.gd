extends Area3D

var life = 30
@onready var cpu_particles_3d = $Particles/CPUParticles3D
@onready var cpu_particles_3d_2 = $Particles/CPUParticles3D2
var alive = false

func _ready():
	visible = false
	cpu_particles_3d.emitting = false
	cpu_particles_3d_2.emitting = false

func hit(dmg):
	$HitFlashAnim.play("hit_flash")
	life = life - dmg
	if life < 30:
		cpu_particles_3d.emitting = true
	if life < 20:
		cpu_particles_3d_2.emitting = true
	if life <= 0:
		alive = false
		if "reset_enemy_pos" in get_parent():
			get_parent().reset_enemy_pos()
		life = 30
		cpu_particles_3d.emitting = false
		cpu_particles_3d_2.emitting = false
		
func _process(delta):
	rotation_degrees.z -= global_rotation_degrees.z * delta /0.5

func activate_enemy():
	alive = true
	visible = true
