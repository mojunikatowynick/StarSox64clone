extends Node

#preloads
#projectiles
const F_BULLET = preload("res://scenes/f_bullet.tscn")

@onready var fox = $RailCart/Fox
@onready var bullets = $Bullets
@onready var world_environment = $WorldEnvironment


func _on_fox_fire(pos, rot):
	var projectile = F_BULLET.instantiate() as Area3D
	projectile.position = pos
	projectile.transform.basis = rot
	bullets.add_child(projectile)

func _process(delta):
	if !fox.barrel:
		world_environment.environment.sky_rotation.z = fox.velocity.x / 15 * delta
		world_environment.environment.sky_rotation.x = - fox.velocity.y / 15 * delta
		bullets.rotation.z = fox.velocity.x / 15 * delta
		bullets.rotation.x = - fox.velocity.y / 15 * delta
