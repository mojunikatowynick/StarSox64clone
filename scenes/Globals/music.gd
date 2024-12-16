extends Node3D

@onready var buildup = $Buildup
@onready var music_menu = $MusicMenu
@onready var music_play = $MusicPlay
@onready var music_boss = $MusicBoss
@onready var hover = $Hover
@onready var button_click = $ButtonClick
@onready var barrel = $Barrel
@onready var start = $Start
@onready var sea_sound = $SeaSound

func game_music():
	music_menu.stop()
	await get_tree().create_timer(1).timeout
	music_play.play()

func _on_buildup_finished():
	music_menu.play()


func _on_music_boss_finished():
	music_play.stream_paused = false 
