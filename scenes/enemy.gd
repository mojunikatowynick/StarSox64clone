extends Area3D

var life = 30
@onready var cpu_particles_3d = $Particles/CPUParticles3D
@onready var cpu_particles_3d_2 = $Particles/CPUParticles3D2
@onready var marker_3d = $WeaponHandler/Marker3D
@onready var fire_timer = $Timer/FireTimer

var alive = false

signal enemy_fire(pos, rot)

func _ready():
	
	connect("enemy_fire", Global.Wrold._on_enemy_enemy_fire)

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
	await get_tree().create_timer(randf_range(2,4)).timeout
	fire_timer.start()

func _on_fire_timer_timeout():
	var fire_rotation = Global.fox_position - marker_3d.global_position
	enemy_fire.emit(marker_3d.global_position, fire_rotation)
