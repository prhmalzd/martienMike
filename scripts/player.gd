extends CharacterBody2D

class_name Player

@export var gravity = 400
@export var speed = 125
@export var jump_force = 200
@onready var animated_sprite = $AnimatedSprite2D
@export var playerGetHurt = false
var active = true

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
	
	var direction = 0
	if active:
		if Input.is_action_pressed("jump") && is_on_floor():
			jump(jump_force, true)
		
		direction = Input.get_axis("move_left","move_right")
	
	if direction != 0 :
		animated_sprite.flip_h = (direction == -1)
	
	velocity.x = direction * speed
	
	move_and_slide()
	if !playerGetHurt:
		update_animation(direction)
	else:
		player_getInjured()
		playerGetHurt = false
	
func update_animation(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
func player_getInjured():
	animated_sprite.play('dead')

	
func jump(force, bool):
	if bool:
		AudioPlayer.play_sfx("jump")
	velocity.y =-force
	
