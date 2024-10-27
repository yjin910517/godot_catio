extends Node2D

var MEOW = load('res://Audios/meow_clip_1.wav')


func _ready():
	$IntroSound.stream = MEOW


func update_dialogue(text):
	$Dialogue.text = " > " + text
	

func run_intro_dialogue():
	update_dialogue("What a beautiful day!")
	await get_tree().create_timer(3).timeout
	$IntroSound.play()
	await get_tree().create_timer(1).timeout
	update_dialogue("???")
	await get_tree().create_timer(2).timeout
	update_dialogue("Did I hear cat meowing?")
	await get_tree().create_timer(3).timeout
	hide()
