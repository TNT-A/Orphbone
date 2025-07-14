extends Node2D

var target_plane 

@onready var explosion_scene = preload("res://orphbone_hit.tscn")

var target : Vector2
var speed : float = 200

func _ready() -> void:
	target_plane = get_parent().get_parent().find_child("target_plane")
	$AnimatedSprite2D.play("fly")
	$AnimationPlayer.play("fly")
	var tween = create_tween()
	tween.tween_property(self, "position", target, .5)

func _physics_process(delta: float) -> void:
	var dir = global_position.direction_to(target)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	spawn_explosion()
	queue_free()

func spawn_explosion():
	var new_explosion = explosion_scene.instantiate()
	new_explosion.global_position = $Marker2D.global_position
	target_plane.add_child(new_explosion)
