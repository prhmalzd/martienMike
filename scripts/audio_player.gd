extends Node

var hurt = preload("res://assets/audio/hurt.wav")
var jump = preload("res://assets/audio/jump.mp3")
var boing = preload("res://assets/audio/boing.mp3")
var win = preload("res://assets/audio/win.mp3")


func play_sfx(fx_name: String):
	
	var asp = AudioStreamPlayer.new()
	var stream = null
	
	if fx_name == 'hurt':
		stream = hurt
	elif fx_name == 'jump':
		stream = jump
		asp.volume_db = -20
	elif fx_name == 'boing':
		stream = boing
	elif fx_name == 'win':
		stream = win
	else:
		print('invalid sfx name')
		return

	asp.stream = stream
	asp.name = "SFX"
	add_child(asp)
	
	asp.play()
	
	await asp.finished
	
	asp.queue_free()
