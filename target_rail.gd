extends Node2D

@export var spawn_speed : int = 5
@export var target_speed : int = 1000

@onready var target_plane = get_parent()
@onready var target_scene = preload("res://bone_target.tscn")
var active : bool = false

func _ready() -> void:
	$SpawnTimer.wait_time = spawn_speed
	print($EndMark.global_position, $BeginningMark.global_position)
	self.visible = false

func spawn_target():
	if active == true:
		var new_target = target_scene.instantiate()
		new_target.type = "moving"
		new_target.speed = target_speed
		new_target.direction = ($EndMark.global_position - $BeginningMark.global_position).normalized()
		new_target.global_position = $BeginningMark.global_position #Vector2($BeginningMark.global_position.x, $BeginningMark.global_position.y)
		target_plane.add_child(new_target)

func _on_spawn_timer_timeout() -> void:
	spawn_target()
