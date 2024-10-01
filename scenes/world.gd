extends Node

#preloads
#projectiles
const F_BULLET = preload("res://scenes/f_bullet.tscn")

@onready var fox = $Level1/Path3D/PathFollow3D/RailCart/Fox
@onready var bullets = $Level1/Path3D/PathFollow3D/RailCart/Bullets
@onready var world_environment = $WorldEnvironment

func _on_fox_fire(pos, rot):
	var projectile = F_BULLET.instantiate() as Area3D
	bullets.add_child(projectile)
	projectile.global_position = pos
	projectile.global_basis = rot
	

func _process(delta):
	if !fox.barrel:
		world_environment.environment.sky_rotation.z = fox.velocity.x / 15 * delta
		world_environment.environment.sky_rotation.x = - fox.velocity.y / 15 * delta
		bullets.rotation.z = fox.velocity.x / 15 * delta
		bullets.rotation.x = - fox.velocity.y / 15 * delta
