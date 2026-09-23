extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"

const SPEED = 80.0

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED

	move_and_slide()
