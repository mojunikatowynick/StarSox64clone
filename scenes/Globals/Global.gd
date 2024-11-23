extends Node

#Fox bullet handler
var bullet_s_pos: Vector3
var bullet_direction: Vector3
var cinematic_bool: bool = true

const flight_speed: int = 100
var asteroid_speed: float = 0.7

@onready var fox_position: Vector3

@onready var Wrold: Node = get_node("/root/World")
