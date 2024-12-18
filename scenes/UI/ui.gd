extends CanvasLayer
@onready var progress_bar = $ProgressBar
@onready var information = $Dialogue/MarginContainer/Information
@onready var end_button = $ButtonCntrl/EndButton
@onready var play_button = $ButtonCntrl/PlayButton
@onready var blackout = $Blackout
@onready var loadingcircle = $Blackout/Control/loadingcircle

signal begin

func _ready():

	Global.connect("fox_life_change", update_fox_life)
	connect("begin", Global.Wrold._on_play_button_pressed)
	
	end_button.modulate = Color(1, 1, 1, 0)
	end_button.visible = false
	play_button.modulate = Color(1, 1, 1, 0)
	
	await get_tree().create_timer(4).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(play_button, "modulate", Color(1, 1, 1), 7)


func loading_done():
	loadingcircle.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(blackout, "modulate", Color(1, 1, 1, 0), 2)
	await tween.finished
	blackout.visible = false

func _process(delta):
	loadingcircle.rotation += 1 * delta


func update_fox_life():
	progress_bar.value = Global.fox_life
	if Global.fox_life > 100:
		Global.fox_life = 100

func dialogue_one():
	information.update_message(
"		Welcome pilot, {p=1.0} 
Today You are going to fly our prototype supersonic aircraft 
{p=0.5}[i]Fox - 64 [/i] 
{p=0.5}Your mission is fairly simple, check all its features
You can start whenever you are ready by pressing the boost button (left shift)")

func dialogue_two():
	information.update_message("Great, use the yoke (W, A, S, D or ARROWS) to change direction.
Try to aim into rings, they will energize nanobots that repairs [i]Fox - 64[/i] ")

	
func dialogue_three():
	if Global.fox_life >= 100:
		information.update_message("Perfect, seems all work in order. Remember, you might find simillar rings in futere!
Wait, {p=0.5} what is that? [b]Asteroids?![/b]
[u]Make evasive manouvers to dodge them! (Q or E to Barrelroll)[/u]")
	elif Global.fox_life < 100:
		information.update_message("Less than perfect, but seems all work in order. Remember, you might find simillar rings in futere!
Wait, {p=0.5} what is that? [b]Asteroids?![/b]
[u]Make evasive manouvers to dodge them! (Q or E to Barrelroll)[/u]")

	await get_tree().create_timer(10).timeout
	Music.game_music()

func dialogue_four():
	information.update_message("You made it! {p=0.5} but watch out
[b]BEHIND YOU[/b]
Use your weapon to shoot them down! (Space to shoot laser)")

func dialogue_five():
	information.update_message("You can also use boost (left shift) to dodge collisions!
[b]Clear those TANGOS! GOOD LUCK![/b]")

func dialogue_six():
	information.update_message("WHAT...{p=0.5} IS... {p=0.5} THAT?!")
	await get_tree().create_timer(3).timeout
	Music.music_play.stream_paused = true 
	Music.music_boss.play()

func dialogue_seven():
	if Global.fox_life <= 0:
		information.update_message("NOOOOOO! .... {p=0.5} we lost him... ")
	elif Global.fox_life < 0:
		information.update_message("Woah, umm, what was all of that?
Nevemind, We need to prepare a report
Fly back to us to refill and debrief, and Pilot {p=0.5}, Good job!")

	await get_tree().create_timer(3).timeout
	var tween = get_tree().create_tween()
	end_button.visible = true
	tween.tween_property(end_button, "modulate", Color(1, 1, 1), 7)


func _on_play_button_mouse_entered():
	Music.hover.play()


func _on_end_button_mouse_entered():
	Music.hover.play()

func _on_play_button_pressed():
	begin.emit()

func _on_end_button_pressed():
	get_tree().quit()
