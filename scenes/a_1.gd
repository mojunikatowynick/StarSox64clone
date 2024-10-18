extends Node3D
	
var move: bool = false
var start_pos: Vector3
@export var change_angle: int
func _ready():
	visible = false
	start_pos = global_position
	#print(start_pos)
	
func _process(_delta):
	if move:
		global_transform.origin = global_transform.origin.move_toward((start_pos + Vector3(-170 * change_angle, -5000, 0)), Global.asteroid_speed)

func move_true():
	visible = true
	move = true
