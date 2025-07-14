extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("explosion")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
