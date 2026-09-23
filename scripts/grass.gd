extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var decayed:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.visible = false

func decay()->void:
	if decayed: return
	sprite_2d.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("decay")

func pause_decay()->void:
	animated_sprite_2d.pause()

func _on_animated_sprite_2d_animation_finished() -> void:
	decayed = true
