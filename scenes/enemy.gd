extends Area3D

var life = 30
@onready var cpu_particles_3d = $Particles/CPUParticles3D
@onready var cpu_particles_3d_2 = $Particles/CPUParticles3D2
@onready var marker_3d = $WeaponHandler/Marker3D
@onready var fire_timer = $Timer/FireTimer
@onready var aim = $Aim
@onready var target = $Aim/Target
@onready var hit_score = $Hit_score
@onready var death = $Death

var alive = false

signal enemy_fire(pos, rot)

func _ready():
	
	connect("enemy_fire", Global.Wrold._on_enemy_enemy_fire)
	visible = false
	cpu_particles_3d.emitting = false
	cpu_particles_3d_2.emitting = false

func hit(dmg):
	hit_score.play()
	$HitFlashAnim.play("hit_flash")
	life = life - dmg
	if life < 30:
		cpu_particles_3d.emitting = true
	if life < 20:
		cpu_particles_3d_2.emitting = true
	if life <= 0:
		death.play()
		cpu_particles_3d.emitting = false
		cpu_particles_3d_2.emitting = false
		alive = false
		if "reset_enemy_pos" in get_parent():
			get_parent().reset_enemy_pos()
		fire_timer.stop()
		visible = false

func _process(delta):

	rotation_degrees.z -= global_rotation_degrees.z * delta /0.5
	aim.look_at(Global.fox_position)
	
func activate_enemy():
	life = 30
	cpu_particles_3d.emitting = false
	cpu_particles_3d_2.emitting = false
	alive = true
	visible = true
	await get_tree().create_timer(randf_range(2,4)).timeout
	fire_timer.start()

func _on_fire_timer_timeout():
	if Global.fox_life > 0 and alive:
		var fire_rotation = target.global_transform.basis
		enemy_fire.emit(marker_3d.global_position, fire_rotation)
