extends Area3D

var rotation_speed: int = 100
var collision_damage: int = 100
var rot_x
var rot_y
var rot_z
var rng = RandomNumberGenerator.new()

func _ready():
	rot_x = rng.randf_range(0, 5.0)
	rot_y = rng.randf_range(0, 5.0)
	rot_z = rng.randf_range(0, 5.0)
	

func _process(delta):
	rotation_degrees.x += rotation_speed * delta * rot_x 
	rotation_degrees.y += rotation_speed * delta * rot_y
	rotation_degrees.z += rotation_speed * delta * rot_z

func _on_body_entered(body):
	if body.is_in_group("Fox"):
		if "hit" in body:
			body.hit(100)

func hit(dmg):
	print(dmg)

func _on_area_entered(area):
	if area.is_in_group("TriggerDissapear"):
		self.visible = false
		await get_tree().create_timer(1).timeout
		queue_free()
