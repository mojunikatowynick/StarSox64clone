extends Area3D

signal take_hit(dmg)

func hit(dmg):
	take_hit.emit(dmg)
