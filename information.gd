class_name Information
extends Control
  
@onready var content: RichTextLabel = $Content
@onready var type_timer: Timer = $TypeTimer
@onready var pause_timer: Timer = $PauseTimer
@onready var voice_player = $VoicePlayer
@onready var pause_calculator = $PauseCalculator

var incomming_msg: bool = false

var _playing_voice: bool = false

func _ready():
	visible = false
# We are going to use this logic to test, will be removed later

# Update the message and starts typing
# Start typing the provided message from func in world
func update_message(message: String) -> void:
	reset_msg()
	visible = true
	await get_tree().create_timer(1).timeout
	content.bbcode_text = pause_calculator.extract_pauses_from_string(message)
	content.visible_characters = 0
	type_timer.start()

func _on_DialogueVoicePlayer_finished() -> void:
	if _playing_voice:
		voice_player.play(0)

func _on_PauseCalculator_pause_requested(duration: float) -> void:
	_playing_voice = false
	type_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()

func _on_pause_timer_timeout():
	_playing_voice = true
	voice_player.play(0)
	type_timer.start()

#typing when thera are letters in message and stops when ends, need to hide all after
func _on_type_timer_timeout():
	pause_calculator.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		voice_player.play(0)
		content.visible_characters += 1
	else:
		type_timer.stop()
		await get_tree().create_timer(3).timeout
		if incomming_msg == false:
			content.clear()
			visible = false
		else:
			incomming_msg = false
			visible = false
		#check_visible()

#func check_visible():
	#if visible:
		#visible = false
	#else:
		#visible = true

func reset_msg():
		type_timer.stop()
		content.clear()
		incomming_msg = true
		#check_visible()
