extends CharacterBody3D
class_name Fox
@onready var fox_1 = $Fox1

#signals
signal fire(pos, rot)
signal death

const MAXSPEED = 20
const ACCEL= 10
const DEACCEL = 0.95

var current_speed_x: float
var current_speed_y: float
var target_velocity = Vector3.ZERO


@onready var col = $CollisionShape3D
@onready var can_barrel_timer = $Timer/CanBarrelTimer
@onready var animation_player = $Animation/AnimationPlayer
@onready var invincible_player = $Animation/InvinciblePlayer
@onready var barrel_end = $WeaponHandler/BarrelEnd
@onready var crosshair = $WeaponHandler/Crosshair
@onready var invincible_timer = $InvincibleTimer
@onready var hit_by = $hit_by
@onready var weapon_handler = $WeaponHandler
@onready var jet_loop = $JetLoop
@onready var score = $Score

var cinematic: bool = true
var barrel: bool = false
var can_barrel: bool = true
var colliders_active: bool = true
var dirX: float


func _ready():
	add_to_group("Fox")
	Global.fox_life = 70
	weapon_handler.visible = false
	connect("death", Global.Wrold.end)

func _physics_process(delta: float) -> void:

	Global.fox_position = global_position
	
	if !cinematic:
		move_and_slide()
		#print(col_left_wing.disabled)
		#basic movement
		if !barrel:
			var input_dir := Input.get_vector( "right", "left", "down", "up" )
			var direction = (global_transform.basis * Vector3(input_dir.x, input_dir.y, 0)).normalized()
			current_speed_x = clamp(current_speed_x, -2, 2)
			current_speed_y = clamp(current_speed_y, -2, 2)
			if direction.x: 
				current_speed_x += delta * ACCEL * direction.x
			else :
				current_speed_x =  current_speed_x * DEACCEL
			if direction.y:
				current_speed_y += delta * ACCEL * direction.y
			else :
				current_speed_y = current_speed_y * DEACCEL

			velocity.x = current_speed_x * MAXSPEED
			velocity.y = current_speed_y * MAXSPEED

			rotation_degrees.x = -velocity.y / 1.5
			fox_1.rotation_degrees.x = -velocity.x * 1.5 
			$CollisionShape3D.rotation_degrees.x = -velocity.x * 1.5 
			rotation_degrees.y = velocity.x / 1.5
			
		# animation of movement

		# clam how far can fly
		transform.origin.x = clamp(transform.origin.x, -55, 55)
		transform.origin.y = clamp(transform.origin.y, -35, 35)
		
		#barrelroll
		if Input.is_action_pressed("rightbarrel") and can_barrel:
			Music.barrel.play()
			barrel = true
			velocity.x = -3000 * delta
			animation_player.play("BarrelRoll")
			can_barrel = false
			can_barrel_timer.start()
			collision_check()
			await get_tree().create_timer(0.4).timeout
			velocity.x = 0
			collision_check()

		if Input.is_action_just_pressed("leftbarrel") and can_barrel:
			Music.barrel.play()
			barrel = true
			velocity.x = 3000 * delta
			animation_player.play_backwards("BarrelRoll")
			can_barrel = false
			can_barrel_timer.start()
			collision_check()
			await get_tree().create_timer(0.4).timeout
			velocity.x = 0
			collision_check()

	#fire handling 
		if Input.is_action_just_pressed("fire"):
			$Laser.play()
			var fire_rotation = barrel_end.global_transform.basis
			fire.emit(barrel_end.global_position, fire_rotation)

func weapon_handler_visible():
	weapon_handler.visible = true
	
func jet_engine_start():
	jet_loop.play()

func collision_check():
	if colliders_active:
		colliders_active = false
		set_collision_mask_value(4, false)

	else:
		colliders_active = true
		#col.set_deferred("disabled", false)
		set_collision_mask_value(4, true)


func _on_can_barrel_timer_timeout():
	can_barrel = true

func _on_animation_player_animation_finished(_BarrelRoll):
	barrel = false

func hit(dmg):
	hit_by.play()
	if Global.fox_life > 0:
		Global.fox_life = Global.fox_life - dmg
		collision_check()
		invincible_player.play("Invincible")
		invincible_timer.start()
	if Global.fox_life <= 0:
		col.disabled = false
		cinematic = true
		animation_player.play("death")
		weapon_handler.visible = false
		death.emit()

func _on_invincible_timer_timeout():
	collision_check()
	
func score_sound():
	score.play()
