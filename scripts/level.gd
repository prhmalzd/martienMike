extends Node2D

@onready var start = $spawn
@export var is_final_level:bool = false
@onready var exit = $exit
@onready var notExit = $notExit
@export var next_level: PackedScene = null
@onready var death_zone = $death_zone
@export var level_time = 360
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer
var greed = preload("res://assets/audio/greed.mp3")
var greedPlaying = false


var win = false
var player = null
var timer_node = null
var time_left

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player !=null:
		player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		#trap.connect("touched_player", _on_trap_touched_player)
		trap.touched_player.connect(_on_trap_touched_player)
	
	exit.body_entered.connect(_on_exit_body_entered)
	if notExit:
		notExit.body_entered.connect(_on_notExit_body_entered)
	death_zone.body_entered.connect(_on_death_zone_body_entered)
	
	time_left = level_time
	hud.set_time_lable(time_left)
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()

func _on_level_timer_timeout():
	if !win:
		time_left -= 1
		hud.set_time_lable(time_left)
		if time_left < 0:
			AudioPlayer.play_sfx("hurt")
			reset_player()
			time_left = level_time
			hud.set_time_lable(time_left)


func _process(delta):
	if Input.is_action_pressed('quit'):
		get_tree().quit()
	elif Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()


func _on_death_zone_body_entered(body):
	AudioPlayer.play_sfx("hurt")
	reset_player()

func _on_trap_touched_player():
	AudioPlayer.play_sfx("hurt")
	player.playerGetHurt = true
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func _on_exit_body_entered(body):
	if body as Player:
		if is_final_level || next_level!=null:
			exit.animate()
			player.active = false
			win = true
			AudioPlayer.play_sfx("win")
			await get_tree().create_timer(3).timeout
			if is_final_level:
				ui_layer.show_win_scree(true)
			else:
				get_tree().change_scene_to_packed(next_level)
				
func _on_notExit_body_entered(body):
	notExit.animate()
	_on_area_2d_body_entered(body)


func _on_area_2d_body_entered(body):
	if (body as Player) && !greedPlaying:
		greedPlaying = true
		AudioPlayer.get_child(0).stream_paused = true
		var asp = AudioStreamPlayer.new()
		asp.stream = greed
		asp.volume_db = -15
		asp.name = "GREED"
		add_child(asp)
		asp.play()
		await get_tree().create_timer(19).timeout
		asp.queue_free()
		AudioPlayer.get_child(0).play()
		greedPlaying = false
		reset_player()
