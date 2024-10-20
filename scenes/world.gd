extends Node

#preloads
#projectiles
const F_BULLET = preload("res://scenes/f_bullet.tscn")

@onready var fox = $Level1/Path3D/PathFollow3D/RailCart/Fox
@onready var bullets = $Bullets
@onready var world_environment = $WorldEnvironment
@onready var path_follow_3d = $Level1/Path3D/PathFollow3D
@onready var fox_camera = $Level1/Path3D/PathFollow3D/RailCart/Camera3D
@onready var animation_player = $Animation/AnimationPlayer
@onready var can_boost_timer = $Timers/CanBoostTimer
@onready var asteroids_1 = $Enviroment/Collisions/Asteroids1


var flying: bool = false
var camera_pos
var can_boost: bool = true

func _ready():
	path_follow_3d.prog_speed = 0
	camera_pos = fox_camera.global_position
	#print(camera_pos)
	animation_player.play("Opening_Cinematic")

#skip cinematic press any key
func _unhandled_input(event):
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE and Global.cinematic_bool:
			animation_player.stop()
			animation_player.play("Start_Anim")
			await animation_player.animation_finished
			Global.cinematic_bool = false
		
		if Input.is_action_just_pressed("boost") and !Global.cinematic_bool and !flying:
			var tween = get_tree().create_tween()
			tween.tween_property(path_follow_3d, "prog_speed", Global.flight_speed, 2)

		if Input.is_action_just_pressed("boost") and !Global.cinematic_bool:
			if flying and can_boost:
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

func _on_fox_fire(pos, rot):
	var projectile = F_BULLET.instantiate() as Area3D
	bullets.add_child(projectile)
	projectile.global_position = pos
	projectile.global_basis = rot

func _on_game_start_body_entered(body):
	if body.is_in_group("Fox"):
		fox.cinematic = false
		flying = true

func _on_can_boost_timer_timeout():
	can_boost = true

func _on_trigger_asteroids_area_entered(area):
	if area.is_in_group("Trigger"):
		for asteroid in asteroids_1.get_children():
			if "move_true" in asteroid:
				asteroid.move_true()


func _on_area_3d_area_entered(area):
	if area.is_in_group("Enemy"):
		if !area.alive and "activate_enemy" in area:
			area.activate_enemy()
