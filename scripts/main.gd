extends Node2D

const GRASS = preload("uid://dbpbym73pawg2")
@onready var player: CharacterBody2D = $Player

var rng = RandomNumberGenerator.new()
var hash_map = Dictionary()

const hash_size:int = 64

var old_position: Vector2i = Vector2i(-99999, -99999) # A value far away from player initial position
var new_position:Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_patch(Vector2(0.0,0.0),Vector2(1000.0,1000.0),100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		return
	var x = int(player.position.x) / hash_size
	var y = int(player.position.y) / hash_size
	
	new_position = Vector2i(x,y)
	
	if old_position != new_position:
		pause_decay_grid(old_position)
		decay_grid(new_position)
		old_position = new_position

func place_grass(x: int, y: int) -> void:
	var grass = GRASS.instantiate()
	grass.position = Vector2(x, y)
	#grass.flip_v = rng.randf() > 0.5
	get_tree().current_scene.add_child(grass)
	
	var grid_x = int(x) / hash_size
	var grid_y = int(y) / hash_size
	var hash_key = Vector2i(grid_x, grid_y)

	if hash_map.has(hash_key):
		hash_map[hash_key].append(grass)
	else:
		hash_map[hash_key] = [grass]


func place_patch(from:Vector2, to:Vector2, num:int)->void:
	for i in range(num):
		var x = rng.randf_range(from.x,to.x)
		var y = rng.randf_range(from.y,to.y)
		place_grass(x,y)

func decay_grid(pot:Vector2i)->void:
	if not hash_map.has(pot):return
	
	for grass in hash_map[pot]:
		grass.decay()
		
func pause_decay_grid(pot:Vector2i)->void:
	if not hash_map.has(pot):return
	
	for grass in hash_map[pot]:
		grass.decay()
