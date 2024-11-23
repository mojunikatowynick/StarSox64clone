extends Area3D

@export var boss_life: int = 1000
var invi: bool = true
var alive: bool = false

@export var hook_dmg: int = 20

signal combat_start

@onready var animation_player = $AnimationPlayer
@onready var eye = $Boss/Eye

func _process(_delta):
	eye.look_at(Global.fox_position)

func _on_eye_take_hit(dmg):
	if invi == false:
		boss_life = boss_life - dmg
		print(boss_life)

func invincible_on():
	invi = true

func invincible_off():
	invi = false

func activate_enemy():
	alive = true
	animation_player.play("Alive")
	print("boss", alive)

func combat():
	animation_player.play("Idle")

func attack():
	var attack_pick: int = randi_range(0,3)
	print(attack_pick)
	if attack_pick <1:
		combat()
	elif attack_pick == 1:
		animation_player.play("Hook1")
	elif attack_pick == 2:
		animation_player.play("Hook2")
	elif attack_pick == 3: 
		animation_player.play("Hook3")
	await animation_player.animation_finished
	combat()

func _on_hook_col_body_entered(body):
	if body.is_in_group("Fox"):
		if "hit" in body:
			body.hit(hook_dmg)
