extends CharacterBody2D
@onready var closing: AudioStreamPlayer2D = $Closing
@onready var player: CharacterBody2D = $"../Player"
@onready var tile_map_layer_2: TileMapLayer = $"../TileMapLayer2"

const SPEED = 80.0
const MAX_DISTANCE = 1000.0 # Distance (in pixels) where audio starts playing

const TILE_SOURCE_ID = 0
const TILE_ATLAS_COORDS = Vector2i(0, 0)

func _ready() -> void:
	closing.max_distance = MAX_DISTANCE

func _physics_process(delta: float) -> void:
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
	if body.is_in_group("player"):
		print("Player contacted")

func handle_footsteps() -> void:
	var distance = global_position.distance_to(player.global_position)
	
	if distance > MAX_DISTANCE:
		if closing.playing:
			closing.stop()
		return

	if not closing.playing:
		closing.play()

	var proximity_factor = 1.0 - clamp(distance / MAX_DISTANCE, 0.0, 1.0)
	closing.volume_db = lerp(1.0, 2.0, proximity_factor)
