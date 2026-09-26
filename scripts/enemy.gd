extends CharacterBody2D

@onready var closing: AudioStreamPlayer = $Closing
@onready var player: CharacterBody2D = $"../Player"
@onready var tile_map_layer_2: TileMapLayer = $"../TileMapLayer2"

const SPEED = 80.0

const TILE_SOURCE_ID = 0
const TILE_ATLAS_COORDS = Vector2i(0,0)

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED
	
	_paint_tile_underneath()

	handle_footsteps()
	move_and_slide()

func _paint_tile_underneath()->void:
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

func handle_footsteps()->void:
	if not closing.playing:
			closing.play()
	else:
		if closing.playing:
			closing.stop()
