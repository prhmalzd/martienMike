extends Area2D

@export var jump_force = 300 
@onready var animatedSprite = $AnimatedSprite2D

func _on_body_entered(body):
	if body is Player:
		AudioPlayer.play_sfx("boing")
		animatedSprite.play("jump")
		body.jump(jump_force , false)
