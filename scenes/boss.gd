extends Area3D

@export var boss_life: int = 1000
@export var boss_2_phase: int = 700
@export var boss_3_phase: int = 300

var invi: bool = true
var alive: bool = false

@export var hook_dmg: int = 20

#signal combat_start
signal reset_enemy
signal boss_dead

@onready var animation_player = $AnimationPlayer
@onready var animation_player_eye = $AnimationPlayerEye
@onready var cpu_particles_3d = $Particles/CPUParticles3D
@onready var cpu_particles_3d_2 = $Particles/CPUParticles3D2
@onready var cpu_particles_3d_3 = $Particles/CPUParticles3D3
@onready var enemy_timer = $EnemyTimer
@onready var eye = $Boss/Eye
@onready var death = $Sounds/Death
@onready var hit_score = $Sounds/Hit_score
@onready var hit_solid = $Sounds/Hit_Solid

func _ready():
	position = Vector3(0,-200,0)
	connect("reset_enemy", Global.Wrold.activate_enemies)
	connect("boss_dead", Global.Wrold.end)

func _process(_delta):
	eye.look_at(Global.fox_position)

func _on_eye_take_hit(dmg):
	if invi == false:
		hit_score.play()
		animation_player_eye.play("Hit_Flash")
		boss_life = boss_life - dmg
		if boss_life < boss_2_phase:
			cpu_particles_3d.emitting = true

		if boss_life < boss_3_phase:
			cpu_particles_3d_2.emitting = true

		if boss_life <= 100:
			cpu_particles_3d_3.emitting = true
			
		if boss_life <= 0:
			animation_player.stop()
			invi = true
			animation_player.play("dead")
			death.play()
			await death.finished
			death.play()

func invincible_on():
	invi = true

func invincible_off():
	invi = false

func activate_enemy(): 
	alive = true
	animation_player.play("Alive")
	await animation_player.animation_finished
	enemy_timer.start()
	#print("boss", alive)

func combat():
	var pick_idle: int = randi_range(0,1)
	#print(pick_idle)
	if pick_idle <1:
		animation_player.play("Idle")
	if pick_idle >=1:
		animation_player.play("Idle_2")

func attack():
	var attack_pick: int = randi_range(0,3)
	#print(attack_pick)
	if boss_life >= boss_2_phase:
		if attack_pick <1:
			combat()
		elif attack_pick == 1:
			animation_player.play("Hook1")
		elif attack_pick == 2:
			animation_player.play("Hook2")
		elif attack_pick == 3: 
			animation_player.play("Hook3")
	elif boss_life < boss_2_phase and boss_life >= boss_3_phase :
		if attack_pick <1:
			combat()
		elif attack_pick == 1:
			animation_player.play("Hook1_fast")
		elif attack_pick == 2:
			animation_player.play("Hook2_fast")
		elif attack_pick == 3: 
			animation_player.play("Hook3_fast")
	elif boss_life < boss_3_phase:
		if attack_pick <1:
			attack()
		elif attack_pick == 1:
			animation_player.play("Hook1_fast")
		elif attack_pick == 2:
			animation_player.play("Hook2_fast")
		elif attack_pick == 3: 
			animation_player.play("Hook3_fast")
	if boss_life >= boss_3_phase:
		await animation_player.animation_finished
		combat()
	elif boss_life < boss_3_phase:
		await animation_player.animation_finished
		if boss_life > 0:
			attack()

func _on_hook_col_body_entered(body):
	if body.is_in_group("Fox"):
		if "hit" in body:
			body.hit(hook_dmg)

func _on_enemy_timer_timeout():
	if boss_life < boss_2_phase:
		reset_enemy.emit()

func _on_area_entered(area):
	if area.is_in_group("FBullet"):
		hit_solid.play()

func dead():
	enemy_timer.stop()
	boss_dead.emit()
	queue_free()
