extends Node

#preloads
#projectiles
const F_BULLET = preload("res://scenes/f_bullet.tscn")
const ENEM_BULLET = preload("res://scenes/enem_bullet.tscn")
const EXPLOSION = preload("res://scenes/explosion.tscn")

@onready var fox = $Level1/Path3D/PathFollow3D/RailCart/Fox
@onready var bullets = $Bullets
@onready var world_environment = $WorldEnvironment
@onready var path_follow_3d = $Level1/Path3D/PathFollow3D
@onready var fox_camera = $Level1/Path3D/PathFollow3D/RailCart/Camera3D
@onready var animation_player = $Animation/AnimationPlayer
@onready var can_boost_timer = $Timers/CanBoostTimer
@onready var asteroids_1 = $Enviroment/Collisions/Asteroids1
@onready var asteroids_2 = $Enviroment/Collisions/Asteroids2
@onready var enemy1 = $Level1/Path3D/PathFollow3D/RailCart/EnemyRails/Path3D/PathFollow3D/Enemy
@onready var enemy2 = $Level1/Path3D/PathFollow3D/RailCart/EnemyRails/Path3D2/PathFollow3D/Enemy
@onready var enemy3 = $Level1/Path3D/PathFollow3D/RailCart/EnemyRails/Path3D3/PathFollow3D/Enemy
@onready var enemy4 = $Level1/Path3D/PathFollow3D/RailCart/EnemyRails/Path3D4/PathFollow3D/Enemy
@onready var ui = $UI
@onready var play_button = $UI/ButtonCntrl/PlayButton
@onready var loading = $load

var loading_check: int = 0

var aureola_enemies
var load_group

var flying: bool = false
var camera_pos
var can_boost: bool = true


func loading_assets():
	for assets in loading.get_children():
		if "load_asset_enemy" in assets:
			assets.load_asset_enemy()

func loading_done_check():
	loading_check = loading_check + 1
	if loading_check >= 1:
		if "loading_done" in ui:
			ui.loading_done()

func _ready():
	
	aureola_enemies = [enemy1, enemy2, enemy3, enemy4]
	loading_assets()
	await get_tree().create_timer(1).timeout
	Music.buildup.play()
	path_follow_3d.prog_speed = 0
	camera_pos = fox_camera.global_position
	#print(camera_pos)
	animation_player.play("Opening_Cinematic")

func explosion(pos):
	var ex_anim = EXPLOSION.instantiate() as Node3D
	bullets.add_child(ex_anim)
	ex_anim.global_position = pos

func _on_play_button_pressed():
	Music.buildup.stop()
	Music.button_click.play()
	Music.sea_sound.play()
	
	if Global.cinematic_bool:
		if "dialogue_one" in ui:
			ui.dialogue_one()
		animation_player.stop()
		animation_player.play("Start_Anim")
		play_button.visible = false
		await animation_player.animation_finished
		Global.cinematic_bool = false
		if "weapon_handler_visible" in fox:
			fox.weapon_handler_visible()

#skip cinematic press any key
func _unhandled_input(_event):
	if Global.cinematic_bool == false:
		if Input.is_action_just_pressed("boost") and !Global.cinematic_bool and !flying:
			Music.start.play()
			var tween = get_tree().create_tween()
			tween.tween_property(path_follow_3d, "prog_speed", Global.flight_speed, 2)

		if Input.is_action_just_pressed("boost") and !Global.cinematic_bool:
			if flying and can_boost:
				Music.barrel.play()
				can_boost = false
				can_boost_timer.start()
				var tween = get_tree().create_tween()
				tween.parallel().tween_property(path_follow_3d, "prog_speed", Global.flight_speed*10, 0.2)
				tween.parallel().tween_property(fox_camera, "fov", 65, 0.2)
				await tween.finished
				var tween2 = get_tree().create_tween()
				tween2.parallel().tween_property(fox_camera, "fov", 75, 0.5)
				tween2.parallel().tween_property(path_follow_3d, "prog_speed", Global.flight_speed, 0.5)

func _process(delta):
	#print(flying)
	if !fox.barrel:
		fox_camera.rotation.z = fox.velocity.x / 15 * delta
		fox_camera.rotation.x = fox.velocity.y / 15 * delta

func _on_game_start_body_entered(body):
	if body.is_in_group("Fox"):
		fox.cinematic = false
		flying = true

func _on_can_boost_timer_timeout():
	can_boost = true

func _on_area_3d_area_entered(area):
	if area.is_in_group("Enemy"):
		if !area.alive and "activate_enemy" in area:
			area.activate_enemy()

func _on_fox_fire(pos, rot):
	var projectile = F_BULLET.instantiate() as Area3D
	bullets.add_child(projectile)
	projectile.global_position = pos
	projectile.global_basis = rot

func _on_enemy_enemy_fire(pos, rot):
	var enem_projectile = ENEM_BULLET.instantiate() as Area3D
	bullets.add_child(enem_projectile)
	enem_projectile.global_position = pos
	enem_projectile.global_basis = rot

func _on_trigger_asteroids_body_entered(body):
	if body.is_in_group("Fox"):
		for asteroid in asteroids_1.get_children():
			if "move_true" in asteroid:
				asteroid.move_true()

func _on_trigger_asteroids_2_body_entered(body):
	if body.is_in_group("Fox"):
		for asteroid in asteroids_2.get_children():
			if "move_true" in asteroid:
				asteroid.move_true()

func _on_trigger_area_entered(area):
	if area.is_in_group("Enemy"):
		if "activate_enemy" in area:
			if !area.alive:
				area.activate_enemy()

func activate_enemies():
	for enemy in aureola_enemies:
		if "activate_enemy" in enemy:
			if !enemy.alive:
				enemy.activate_enemy()

func _on_dialogue_two_body_entered(body):
	if body.is_in_group("Fox"):
		if "dialogue_two" in ui:
			ui.dialogue_two()
			fox.jet_engine_start()

func _on_dialogue_three_body_entered(body):
	if body.is_in_group("Fox"):
		if "dialogue_three" in ui:
			ui.dialogue_three()

func _on_dialogue_four_body_entered(body):
	if body.is_in_group("Fox"):
		if "dialogue_four" in ui:
			ui.dialogue_four()

func _on_dialogue_five_body_entered(body):
	if body.is_in_group("Fox"):
		if "dialogue_five" in ui:
			ui.dialogue_five()

func _on_dilogue_six_body_entered(body):
	if body.is_in_group("Fox"):
		if "dialogue_six" in ui:
			ui.dialogue_six()

func end():
	if "dialogue_seven" in ui:
		ui.dialogue_seven()
		for enemy in aureola_enemies:
			enemy.hit(30)

func _on_end_button_pressed():
	get_tree().quit()
