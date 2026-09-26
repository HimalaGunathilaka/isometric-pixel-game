extends CharacterBody2D

@onready var footsteps: AudioStreamPlayer = $Footsteps
var SPEED: int = 200

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	#look_at(get_global_mouse_position())

	var direction: Vector2 = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)
	

	if velocity == Vector2(0,0):
		animated_sprite_2d.frame = 0

	velocity = direction * SPEED
	move_and_slide()

	handle_footsteps(direction)
	start_animation(direction)
	
func handle_footsteps(direction:Vector2)->void:
	if direction != Vector2.ZERO:
		if not footsteps.playing:
			footsteps.play()
	else:
		if footsteps.playing:
			footsteps.stop()

func start_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		return

	direction = direction.normalized()

	var angle := direction.angle()

	if angle >= -PI / 8 and angle < PI / 8:
		# Right
		animated_sprite_2d.play("E")

	elif angle >= PI / 8 and angle < 3 * PI / 8:
		# Down-right
		animated_sprite_2d.play("SE")

	elif angle >= 3 * PI / 8 and angle < 5 * PI / 8:
		# Down
		animated_sprite_2d.play("S")

	elif angle >= 5 * PI / 8 and angle < 7 * PI / 8:
		# Down-left
		animated_sprite_2d.play("SW")

	elif angle >= 7 * PI / 8 or angle < -7 * PI / 8:
		# Left
		animated_sprite_2d.play("W")

	elif angle >= -7 * PI / 8 and angle < -5 * PI / 8:
		# Up-left
		animated_sprite_2d.play("NW")

	elif angle >= -5 * PI / 8 and angle < -3 * PI / 8:
		# Up
		animated_sprite_2d.play("N")

	elif angle >= -3 * PI / 8 and angle < -PI / 8:
		# Up-right
		animated_sprite_2d.play("NE")
