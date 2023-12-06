extends Area2D

@onready var animation_sprite = $AnimatedSprite2D

func animate():
	animation_sprite.play("exit")
