extends StaticBody2D

@onready var spawn_pos = $spawnPosition

func get_spawn_pos():
	return spawn_pos.global_position
