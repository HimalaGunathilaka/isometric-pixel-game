extends CharacterBody2D
@onready var closing: AudioStreamPlayer2D = $Closing
@onready var player: CharacterBody2D = $"../Player"
@onready var tile_map_layer_2: TileMapLayer = $"../TileMapLayer2"
@onready var timer_2: Timer = $Timer2
@onready var timer: Timer = $Timer

var rng = RandomNumberGenerator.new()
const SPEED = 80.0
const MAX_DISTANCE = 1000.0 # Distance (in pixels) where audio starts playing

const TILE_SOURCE_ID = 0
const TILE_ATLAS_COORDS = Vector2i(0, 0)

var disable_physics:bool = false

func _ready() -> void:
	closing.max_distance = MAX_DISTANCE
	
	timer.one_shot = true
	timer.stop()
	timer.wait_time = rng.randf_range(0.5,1.5)
	
	# 5 to 30 seconds
	timer_2.wait_time = rng.randf_range(5,10)
	timer_2.start()

func _physics_process(delta: float) -> void:
	if disable_physics:
		if closing.playing:
			closing.stop()
		return
	
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	
	_paint_tile_underneath()
	handle_footsteps()
	move_and_slide()

func _paint_tile_underneath() -> void:
	var local_position = tile_map_layer_2.to_local(global_position)
	var map_position = tile_map_layer_2.local_to_map(local_position)
	
	tile_map_layer_2.set_cell(
		map_position,
		TILE_SOURCE_ID,
		TILE_ATLAS_COORDS
	)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not disable_physics:
		print("Player contacted")
		player.die()

func handle_footsteps() -> void:
	var distance = global_position.distance_to(player.global_position)
	
	if distance > MAX_DISTANCE:
		if closing.playing:
			closing.stop()
		return

	if not closing.playing:
		closing.play()

	var proximity_factor = 1.0 - clamp(distance / MAX_DISTANCE, 0.0, 1.0)
	closing.volume_db = lerp(-24.0, 0.0, proximity_factor)


func _on_timer_timeout() -> void:
	teleport()
	disable_physics = false
	timer.stop()
	
	timer_2.wait_time = rng.randf_range(5,10)
	timer_2.start()
	
func teleport()->void:
	var player_pot:Vector2 = player.global_position 
	var teleport:Vector2 = get_random_point_on_edge(player_pot,500)
	global_position = teleport
	

func get_random_point_on_edge(center:Vector2,radius:float)->Vector2:
	var angle := randf()*TAU
	var dist := 2*radius * sqrt(randf())
	return center + Vector2(cos(angle),sin(angle))*max(radius,radius / 2)

func _on_timer_2_timeout() -> void:
	disable_physics = true
	timer_2.stop()
	
	timer.wait_time = rng.randf_range(0.5,1.5)
	timer.start()
	
	
