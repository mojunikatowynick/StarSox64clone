extends Area3D

var life = 30
@onready var cpu_particles_3d = $Particles/CPUParticles3D
@onready var cpu_particles_3d_2 = $Particles/CPUParticles3D2
@onready var marker_3d = $WeaponHandler/Marker3D
@onready var fire_timer = $Timer/FireTimer
@onready var aim = $Aim
@onready var target = $Aim/Target
@onready var animation_player = $AnimationPlayer
@onready var hit_score = $Hit_score
@onready var death = $Death

@export var spawn_place_relative: Vector3 = Vector3(-20, 20, 0)
var start_pos: Vector3

var alive = false

signal enemy_fire(pos, rot)

func _ready():
	var s_pos_x: int = randi_range(-35,35)
	var s_pos_y: int = randi_range(-35,35)
	var s_pos_z: float = global_position.z
	position = Vector3(s_pos_x, s_pos_y, s_pos_z)
	start_pos = global_position
	connect("enemy_fire", Global.Wrold._on_enemy_enemy_fire)
	visible = false
	cpu_particles_3d.emitting = false
	cpu_particles_3d_2.emitting = false

func hit(dmg):
	if alive:
		hit_score.play()
		animation_player.play("hit_flash")
		life = life - dmg
		if life < 30:
			cpu_particles_3d.emitting = true
		if life < 20:
			cpu_particles_3d_2.emitting = true
		if life <= 0:
			visible = false
			alive = false
			death.play()
			await death.finished
			queue_free()

func activate_enemy():
	global_position = start_pos + spawn_place_relative
	rotation_degrees.z = -360
	visible = true
	alive = true
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "global_position", start_pos, 2)
	tween.tween_property(self, "rotation_degrees", Vector3.ZERO, 2)
	await get_tree().create_timer(randf_range(2,3)).timeout
	fire_timer.start()

func _on_fire_timer_timeout():
	var fire_rotation = target.global_transform.basis
	enemy_fire.emit(marker_3d.global_position, fire_rotation)
	
