extends Node2D

@onready var target_scene = preload("res://bone_target.tscn")
@onready var target_plane = get_parent()

@export var spawn_speed : int = randi_range(3,5)
var active : bool = false

func _ready() -> void:
	$SpawnTimer.wait_time = spawn_speed
	$SpawnTimer.start()

func rand_valid_pos():
	var pos
	var x
	var y
	x = randi_range(15, 145)
	y = randi_range(10 ,80)
	pos = Vector2(x, y)
	return pos

func spawn_reg_target():
	if active == true:
		var new_target = target_scene.instantiate()
		new_target.global_position = rand_valid_pos()
		new_target.type = "stationary"
		new_target.health = 3
		target_plane.add_child(new_target)

func _on_spawn_timer_timeout() -> void:
	spawn_reg_target()
